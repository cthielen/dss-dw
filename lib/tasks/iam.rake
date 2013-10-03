# Import person data from UCD IAM.

namespace :iam do
  desc 'Import data from IAM.'
  task :import, [:iamID] => :environment do |t, args|
    IAM_SETTINGS_FILE = "config/iam.yml"

    require 'net/http'
    require 'json'
    require 'yaml'

    Bundler.require

    load 'UcdLookups.rb'

    # In case you receive SSL certificate verification errors
    require 'openssl'
    OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

    # Initialize variables
    @total = @successfullySaved = @erroredOut = @noKerberos = 0
    timestamp_start = Time.now

    # Import the IAM site and key from the yaml file
    if File.file?(IAM_SETTINGS_FILE)
      $IAM_SETTINGS = YAML.load_file(IAM_SETTINGS_FILE)
      @site = $IAM_SETTINGS['HOST']
      @key = $IAM_SETTINGS['KEY']
      @iamId = args.iamID
    else
      puts "You need to set up config/iam.yml before running this application."
      exit
    end

    # In case no arguments are provided, we fetch for all people in UcdLookups departments
    if @iamId.nil?
      # Fetch for all people in UcdLookups departments
      for d in UcdLookups::DEPT_CODES.keys()
        # Fetch department members
        url = "#{@site}iam/associations/pps/search?deptCode=#{d}&key=#{@key}&v=1.0"

        # Loop over members
        fetch_url(url).each do |p|
          @total += 1
          fetch_by_iamId(p["iamId"])
        end
      end
      for m in UcdLookups::MAJORS.values()
        Rails.logger.info "Processing graduate students in #{m}"
        url = "#{@site}iam/associations/sis/search?collegeCode=GS&majorCode=#{m}&key=#{@key}&v=1.0"

        # Loop over members
        fetch_url(url).each do |p|
          @total += 1
          fetch_by_iamId(p["iamId"])
        end
      end
    else
      fetch_by_iamId(@iamId)
      @total = 1
    end

    timestamp_finish = Time.now

    Rails.logger.info "\n\nFinished processing a total of #{@total}:\n"
    Rails.logger.info "\t- #{@successfullySaved} successfully saved.\n"
    Rails.logger.info "\t- #{@noKerberos} did not have LoginID in IAM.\n"
    Rails.logger.info "\t- #{@erroredOut} errored out due to some missing fields.\n"
    Rails.logger.info "Time elapsed: " + Time.at(timestamp_finish - timestamp_start).gmtime.strftime('%R:%S')
    
    Status.people_tally = Person.count
    Status.last_iam_import = Time.now
  end
  
  # Method to get response from given URL
  def fetch_url(url)
    begin
      # Fetch URL
      resp = Net::HTTP.get_response(URI.parse(url))
      # Parse results
      buffer = resp.body
      result = JSON.parse(buffer)
    
      return result["responseData"]["results"]
    rescue StandardError => e
      $stderr.puts "Could not connect to IAM server -- #{e.message}"
      return []
    end
  end
  
  # Method to get individual info
  def fetch_by_iamId(id)
    # Fetch the person
    url = "#{@site}iam/people/search/?iamId=#{id}&key=#{@key}&v=1.0"
    personInfo = fetch_url(url)[0]

    # Fetch the contact info
    url = "#{@site}iam/people/contactinfo/#{id}?key=#{@key}&v=1.0"
    personContact = fetch_url(url)[0]

    # Fetch the kerberos userid
    url = "#{@site}iam/people/prikerbacct/#{id}?key=#{@key}&v=1.0"
    begin
      loginid = fetch_url(url)[0]["userId"]
    rescue
      Rails.logger.info "ID# #{id} does not have a loginId in IAM"
    end

    # Fetch the association
    url = "#{@site}iam/associations/pps/search?iamId=#{id}&key=#{@key}&v=1.0"
    associations = fetch_url(url)

    # Fetch the student associations
    url = "#{@site}iam/associations/sis/#{id}?key=#{@key}&v=1.0"
    student_associations = fetch_url(url)

    begin
      # Insert results in database
      person = Person.find_or_create_by_iam_id(iam_id: id)

      if person.id.nil?
        Rails.logger.info "Imported #{personInfo['oFirstName']} #{personInfo['oLastName']} (IAM ID #{id})"
      else
        Rails.logger.info "Updated #{personInfo['oFirstName']} #{personInfo['oLastName']} (IAM ID #{id})"
      end

      person.d_first = personInfo["dFirstName"]
      person.d_middle = personInfo["dMiddleName"]
      person.d_last = personInfo["dLastName"]
      person.o_first = personInfo["oFirstName"]
      person.o_middle = personInfo["oMiddleName"]
      person.o_last = personInfo["oLastName"]
      person.is_faculty = personInfo["isFaculty"]
      person.is_staff = personInfo["isStaff"]
      person.is_student = personInfo["isStudent"]
      person.email = personContact["email"]
      person.phone = personContact["workPhone"] unless personContact["workPhone"].nil?
      person.address = personContact["postalAddress"]
      person.loginid = loginid

      @successfullySaved += 1 if person.save
      
      # PPS Associations
      associations.each do |a|
        department = Department.find_or_create_by_code(code: a["deptCode"], description: a["deptOfficialName"])
        title = Title.find_or_create_by_code(code: a["titleCode"], o_name: a["titleOfficialName"], d_name: a["titleDisplayName"])
        relationship = Relationship.find_or_create_by_person_id_and_is_sis_and_is_pps_and_title_id(person_id: person.id, is_pps: true, is_sis: false, department_id: department.id, title_id: title.id)
        person.relationships << relationship
      end

      # SIS Associations
      student_associations.each do |a|
        major = Major.find_or_create_by_code(code: a["majorCode"], description: a["majorName"])
        college = College.find_or_create_by_code(code: a["collegeCode"], description: a["collegeName"])
        relationship = Relationship.find_or_create_by_person_id_and_is_sis_and_is_pps_and_major_id(person_id: person.id, is_pps: false, is_sis: true, major_id: major.id, college_id: college.id)
        person.relationships << relationship
      end
      
      person.save
      
    rescue StandardError => e
      Rails.logger.info "Cannot process ID#: #{id} -- #{e.message} #{e.backtrace}"
      @erroredOut += 1
    end
  end
end
