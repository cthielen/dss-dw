# Parses information from Banner into Ruby-based ORM modeling

namespace :banner do
  desc 'Runs the Banner import. Takes approx. ?? minutes.'
  task :import => :environment do
    require 'oci8'
    require 'yaml'

    # For debugging
    load 'ObjectStash.rb'
    require 'pp'
    require 'bigdecimal'
    load 'stopwatch.rb'

    # NOTE: Oracle bits disabled while logic is worked through. Query is stored in file 'courses.stash'.
    banner_config = YAML.load_file("#{Rails.root.to_s}/config/banner.yml")

    # Required for Oracle Instant Client
    ENV['DYLD_LIBRARY_PATH'] = banner_config['banner']['DYLD_LIBRARY_PATH']
    ENV['TNS_ADMIN'] = banner_config['banner']['TNS_ADMIN']
    
    # Username, password, database
    conn = OCI8.new(banner_config['banner']['username'], banner_config['banner']['password'], banner_config['banner']['dbname'])
    
    puts "Connected. Querying ..."
    
    cursor = nil # must establish in this scope
    
    cursor = conn.exec("SELECT count(*) FROM AS_CATALOG_SCHEDULE WHERE TERM_CODE_KEY = '201301'")
    r = cursor.fetch_hash()
    row_count = r["COUNT(*)"]
    
    elapsed = Stopwatch.time do
      cursor = conn.exec("SELECT * FROM AS_CATALOG_SCHEDULE WHERE TERM_CODE_KEY = '201301'")
    end
    
    puts "Query complete. Time elapsed: #{elapsed} seconds"
    
    puts "Fetching rows..."
    
    courses = []
    elapsed = Stopwatch.time do
      while r = cursor.fetch_hash()
        courses << r
        puts "Fetched row. Courses now at #{courses.length} of #{row_count}."
      end
    end
    
    puts "Took #{elapsed} seconds."
    
    puts "Saving to disk..."
    
    ObjectStash.store courses, 'courses.stash'
    
    cursor.close
    conn.logoff

    puts "done."
    
    exit



    courses = ObjectStash.load 'courses.stash'

    # Each row is a course
    #while r = cursor.fetch_hash()
    courses.each do |r|
  
      pp r
  
      # Note: Multiple rows for the same course may exist, indicating different sections
      # Note: We use find_or_initialize_by and not find_or_create_by. This allows us to use
      #       new_record? and avoids setting information on old records resulting in needless queries.

      # Parse term information
      term = Term.find_or_initialize_by_code(r["TERM_CODE_KEY"]) # "201301"
      if term.new_record?
        term.description = r["TERM_DESC"] # "Winter Quarter 2013"
        term.save
      end
  
      # Parse department information
      department = Department.find_or_initialize_by_code(r["DEPT_CODE"]) # "HIS"
      if department.new_record?
        department.description = r["DEPT_DESC"] # "History"
        department.save
      end

      # Parse instructor information
      instructor = Instructor.find_or_initialize_by_instructor_id(r["PRIMARY_INSTRUCTOR_ID"]) # "806092270"
      if instructor.new_record?
        instructor.last_name = r["PRIMARY_INSTRUCTOR_LAST_NAME"] # "Tezcan"
        instructor.first_name = r["PRIMARY_INSTRUCTOR_FIRST_NAME"] # "Baki"
        instructor.middle_initial = r["PRIMARY_INSTRUCTOR_MIDDLE_INIT"] # nil
        instructor.save
      end
      # instructor2, instructor3 - not TAs
  
      college = College.find_or_initialize_by_code(r["COLL_CODE"]) # "LS"
      if college.new_record?
        college.description = r["COLL_DESC"] # "Letters & Science"
        college.save
      end
  
      subject = Subject.find_or_create_by_code(r["SUBJ_CODE"]) # "HIS"
      if subject.new_record?
        subject.description = r["SUBJ_DESC"] # "History"
        subject.save
      end
  
      campus = Campus.find_or_create_by_code(r["CAMP_CODE"]) # "M"
      if campus.new_record?
        campus.description = r["CAMP_DESC"] # "Main Campus - Davis"
        campus.save
      end
  
      course = Course.find_or_initialize_by_subject_id_and_number(subject.id, r["CRSE_NUMBER"])
      if course.new_record?
        puts "Found a new course"
        course.title = r["TITLE"] # "Intro to Middle East"
        course.number = r["CRSE_NUMBER"] # "006"
        course.effective_term = Term.find_or_create_by_code_and_description(r["COURSE_EFF_TERM_CODE"], r["COURSE_EFF_TERM_DESC"])
        course.save
      else
        puts "Found a new section for existing course"
      end
  
      grading = GradingType.find_or_initialize_by_code(r["GMOD_CODE"]) # 'N'
      if grading.new_record?
        grading.description = r["GMOD_DESC"] # "Normal/Letter Grading"
        grading.save
      end
  
      term_type = TermType.find_or_create_by_code_and_description(r["PTRM_CODE"], r["PTRM_DESC"]) # '1', "Full Term"
  
      # A CourseOffering is an instance of a Course in a given Term, i.e. a 'CourseTerm'
      offering = CourseOffering.new({
        :crn => r["CRN_KEY"], # "73502"
        :active => r["ACTIVE_COURSE_IND"] == 'Y',
        :term => term,
        :department => department,
        :instructor => instructor,
        :college => college,
        :course => course,
        :grading => grading, # college, department, and grading go with CourseTerm or Course? (term_type too),
        :term_type => term_type,
        :start_date => r["PTRM_START_DATE"],
        :end_date => r["PTRM_END_DATE"]
      })
  
      section = Section.new(:sequence => r["SEQ_NUMBER_KEY"]) # "A01"
      section.max_enrollment = r["MAXIMUM_ENROLLMENT"]
      section.actual_enrollment = r["ACTUAL_ENROLLMENT"]
      # section.seats_available = maximum_enrollment - actual_enrollment
      section.active = r["ACTIVE_SECTION_IND"] == 'Y'
      # Should campus data be assigned per-section or per-course?
      section.campus = campus
      offering.sections << section
  
  
  
      # CRNs are repeated in numerous rows? no.
  
      
      offering.save
  
    end

    # cursor.close
    # conn.logoff
  end
end



# data = {
#   # Core requirement and prerequisite requirement? Is this data relevant to us?
#  # "COURSE_COREQ_IND"=>"N",
#  # "COURSE_PREREQ_IND"=>"N",
#  # "SECTION_COREQ_IND"=>"N",
#  # "SECTION_PREREQ_IND"=>"N",
#  
#  # ???
#  # "DIVS_CODE"=>nil,
#  # "DIVS_DESC"=>nil,
#  # "CEU_IND"=>nil,
#  # "CSTA_CODE"=>"A",
#  # "CSTA_DESC"=>"Active",
#  
#  # Not sure how to parse this out when only 'low' is set and 'CREDIT_HOURS' is not.
#  # Seems like they should be using a function here?
#  # "CREDIT_HOURS"=>nil, # <-- this is always nil, for all terms in the view. why?
#  "CREDIT_HOURS_LOW"=>4.0,
#  "CREDIT_HOURS_HIGH"=>nil, # store as range
#  # "CREDIT_HOURS_IND"=>nil,
#  
#  # Relevant to us?
#  # "BILLING_HOURS"=>"#<BigDecimal:7ffd72a67148,'0.4E1',9(18)>",
#  # "BILLING_HOURS_LOW"=>4.0,
#  # "BILLING_HOURS_HIGH"=>nil,
#  # "BILLING_HOURS_IND"=>nil,
# 
#  # Indicates course is open? Different from ACTIVE_COURSE_IND?
#  # ???
#  # "SSTS_CODE"=>"O",
#  # "SSTS_DESC"=>"Open",
# 
#  # ???
#  # "SAPR_CODE"=>nil,
#  # "SAPR_DESC"=>nil,
#  
#  # Do we need this if we pull nightly? Presumably it's reflected in actual_enrollment
#  # "CENSUS_ENROLLMENT1"=>12,
#  # "CENSUS_ENROLLMENT_DATE1"=>"2013-01-28 00:00:00 -0700",
#  # "CENSUS_ENROLLMENT2"=>0,
#  # "CENSUS_ENROLLMENT_DATE2"=>nil,
# 
#  # ???
#  # "PROJECTED_ENROLLMENT"=>0,
# 
#  # ???
#  # "LINK_IDENTIFIER"=>nil,
# 
#  # It looks as though these times (1,2,3,4,5,6,7,8,9,10) relate to the schedule
#  # type via the code but _not_ the number, e.g. this sample data has schedules under
#  # numbers 1 and 4 but BEGIN_TIME/ROOM_CODE under 1 and 2.
#  # Is SCHD_CODE unique enough then, e.g. could there be two lectures? Three discussions?
#  # Two labs?
#  
#  # all timing info goes under section
#  "BEGIN_TIME1"=>"0900",
#  "END_TIME1"=>"1020",
#  "BLDG_CODE1"=>"VEIMYR",
#  "BLDG_DESC1"=>"Veihmeyer Hall",
#  "ROOM_CODE1"=>"00212",
#  "ROOM_DESC1"=>"General Assignment Room",
#  "SCHD_CODE_MEET1"=>"A",
#  "MONDAY_IND1"=>nil,
#  "TUESDAY_IND1"=>"T",
#  "WEDNESDAY_IND1"=>nil,
#  "THURSDAY_IND1"=>"R",
#  "FRIDAY_IND1"=>nil,
#  "SATURDAY_IND1"=>nil,
#  "SUNDAY_IND1"=>nil,
# 
#  "BEGIN_TIME2"=>"1100",
#  "END_TIME2"=>"1150",
#  "BLDG_CODE2"=>"WELLMN",
#  "BLDG_DESC2"=>"Wellman Hall",
#  "ROOM_CODE2"=>"00005",
#  "ROOM_DESC2"=>"General Assignment",
#  "SCHD_CODE_MEET2"=>"D",
#  "MONDAY_IND2"=>nil,
#  "TUESDAY_IND2"=>"T",
#  "WEDNESDAY_IND2"=>nil,
#  "THURSDAY_IND2"=>nil,
#  "FRIDAY_IND2"=>nil,
#  "SATURDAY_IND2"=>nil,
#  "SUNDAY_IND2"=>nil,
#  
#  "BEGIN_TIME3"=>nil,
#  "END_TIME3"=>nil,
#  "BLDG_CODE3"=>nil,
#  "BLDG_DESC3"=>nil,
#  "ROOM_CODE3"=>nil,
#  "ROOM_DESC3"=>nil,
#  "SCHD_CODE_MEET3"=>nil,
#  "MONDAY_IND3"=>nil,
#  "TUESDAY_IND3"=>nil,
#  "WEDNESDAY_IND3"=>nil,
#  "THURSDAY_IND3"=>nil,
#  "FRIDAY_IND3"=>nil,
#  "SATURDAY_IND3"=>nil,
#  "SUNDAY_IND3"=>nil,
#  
#  "BEGIN_TIME4"=>nil,
#  "END_TIME4"=>nil,
#  "BLDG_CODE4"=>nil,
#  "BLDG_DESC4"=>nil,
#  "ROOM_CODE4"=>nil,
#  "ROOM_DESC4"=>nil,
#  "SCHD_CODE_MEET4"=>nil,
#  "MONDAY_IND4"=>nil,
#  "TUESDAY_IND4"=>nil,
#  "WEDNESDAY_IND4"=>nil,
#  "THURSDAY_IND4"=>nil,
#  "FRIDAY_IND4"=>nil,
#  "SATURDAY_IND4"=>nil,
#  "SUNDAY_IND4"=>nil,
#  
#  "BEGIN_TIME5"=>nil,
#  "END_TIME5"=>nil,
#  "BLDG_CODE5"=>nil,
#  "BLDG_DESC5"=>nil,
#  "ROOM_CODE5"=>nil,
#  "ROOM_DESC5"=>nil,
#  "SCHD_CODE_MEET5"=>nil,
#  "MONDAY_IND5"=>nil,
#  "TUESDAY_IND5"=>nil,
#  "WEDNESDAY_IND5"=>nil,
#  "THURSDAY_IND5"=>nil,
#  "FRIDAY_IND5"=>nil,
#  "SATURDAY_IND5"=>nil,
#  "SUNDAY_IND5"=>nil,
#  
#  "BEGIN_TIME6"=>nil,
#  "END_TIME6"=>nil,
#  "BLDG_CODE6"=>nil,
#  "BLDG_DESC6"=>nil,
#  "ROOM_CODE6"=>nil,
#  "ROOM_DESC6"=>nil,
#  "SCHD_CODE_MEET6"=>nil,
#  "MONDAY_IND6"=>nil,
#  "TUESDAY_IND6"=>nil,
#  "WEDNESDAY_IND6"=>nil,
#  "THURSDAY_IND6"=>nil,
#  "FRIDAY_IND6"=>nil,
#  "SATURDAY_IND6"=>nil,
#  "SUNDAY_IND6"=>nil,
#  
#  "BEGIN_TIME7"=>nil,
#  "END_TIME7"=>nil,
#  "BLDG_CODE7"=>nil,
#  "BLDG_DESC7"=>nil,
#  "ROOM_CODE7"=>nil,
#  "ROOM_DESC7"=>nil,
#  "SCHD_CODE_MEET7"=>nil,
#  "MONDAY_IND7"=>nil,
#  "TUESDAY_IND7"=>nil,
#  "WEDNESDAY_IND7"=>nil,
#  "THURSDAY_IND7"=>nil,
#  "FRIDAY_IND7"=>nil,
#  "SATURDAY_IND7"=>nil,
#  "SUNDAY_IND7"=>nil,
#  
#  "BEGIN_TIME8"=>nil,
#  "END_TIME8"=>nil,
#  "BLDG_CODE8"=>nil,
#  "BLDG_DESC8"=>nil,
#  "ROOM_CODE8"=>nil,
#  "ROOM_DESC8"=>nil,
#  "SCHD_CODE_MEET8"=>nil,
#  "MONDAY_IND8"=>nil,
#  "TUESDAY_IND8"=>nil,
#  "WEDNESDAY_IND8"=>nil,
#  "THURSDAY_IND8"=>nil,
#  "FRIDAY_IND8"=>nil,
#  "SATURDAY_IND8"=>nil,
#  "SUNDAY_IND8"=>nil,
#  
#  "BEGIN_TIME9"=>nil,
#  "END_TIME9"=>nil,
#  "BLDG_CODE9"=>nil,
#  "BLDG_DESC9"=>nil,
#  "ROOM_CODE9"=>nil,
#  "ROOM_DESC9"=>nil,
#  "SCHD_CODE_MEET9"=>nil,
#  "MONDAY_IND9"=>nil,
#  "TUESDAY_IND9"=>nil,
#  "WEDNESDAY_IND9"=>nil,
#  "THURSDAY_IND9"=>nil,
#  "FRIDAY_IND9"=>nil,
#  "SATURDAY_IND9"=>nil,
#  "SUNDAY_IND9"=>nil,
#  
#  "BEGIN_TIME10"=>nil,
#  "END_TIME10"=>nil,
#  "BLDG_CODE10"=>nil,
#  "BLDG_DESC10"=>nil,
#  "ROOM_CODE10"=>nil,
#  "ROOM_DESC10"=>nil,
#  "SCHD_CODE_MEET10"=>nil,
#  "MONDAY_IND10"=>nil,
#  "TUESDAY_IND10"=>nil,
#  "WEDNESDAY_IND10"=>nil,
#  "THURSDAY_IND10"=>nil,
#  "FRIDAY_IND10"=>nil,
#  "SATURDAY_IND10"=>nil,
#  "SUNDAY_IND10"=>nil,
#  
#  # "ATTR_CODE1"=>nil,
#  # "ATTR_DESC1"=>nil,
#  # "ATTR_CODE2"=>nil,
#  # "ATTR_DESC2"=>nil,
#  # "ATTR_CODE3"=>nil,
#  # "ATTR_DESC3"=>nil,
#  # "ATTR_CODE4"=>nil,
#  # "ATTR_DESC4"=>nil,
#  # "ATTR_CODE5"=>nil,
#  # "ATTR_DESC5"=>nil,
#  # 
#  # "ADDITIONAL_ATTRIBUTES_IND"=>"Y",
#  
#  # Is the first always a professor and the rest are TAs? Should we store all of them
#  # under 'instructors' or should we differentiate?
#  "INSTRUCTOR_ID2"=>nil,
#  "INSTRUCTOR_LAST_NAME2"=>nil,
#  "INSTRUCTOR_FIRST_NAME2"=>nil,
#  "INSTRUCTOR_MIDDLE_INIT2"=>nil,
#  
#  "INSTRUCTOR_ID3"=>nil,
#  "INSTRUCTOR_LAST_NAME3"=>nil,
#  "INSTRUCTOR_FIRST_NAME3"=>nil,
#  "INSTRUCTOR_MIDDLE_INIT3"=>nil,
# 
#  # "ADDITIONAL_INSTRUCTORS_IND"=>"N",
#  
#  # ???
#  # "COLL_CODE_OVERRIDE"=>nil,
#  # "COLL_DESC_OVERRIDE"=>nil,
#  # "DIVS_CODE_OVERRIDE"=>nil,
#  # "DIVS_DESC_OVERRIDE"=>nil,
#  # "DEPT_CODE_OVERRIDE"=>nil,
#  # "DEPT_DESC_OVERRIDE"=>nil,
#  
#  
#  "SCHD_CODE1"=>"A",
#  "SCHD_DESC1"=>"LEC",
#  "SCHD_WORKLOAD1"=>nil,
#  "SCHD_MAX_ENRL1"=>nil,
#  "SCHD_ADJ_WORKLOAD1"=>nil,
# 
#  "SCHD_CODE2"=>nil,
#  "SCHD_DESC2"=>nil,
#  "SCHD_WORKLOAD2"=>nil,
#  "SCHD_MAX_ENRL2"=>nil,
#  "SCHD_ADJ_WORKLOAD2"=>nil,
# 
#  "SCHD_CODE3"=>nil,
#  "SCHD_DESC3"=>nil,
#  "SCHD_WORKLOAD3"=>nil,
#  "SCHD_MAX_ENRL3"=>nil,
#  "SCHD_ADJ_WORKLOAD3"=>nil,
# 
#  "SCHD_CODE4"=>"D",
#  "SCHD_DESC4"=>"DIS",
#  "SCHD_WORKLOAD4"=>nil,
#  "SCHD_MAX_ENRL4"=>nil,
#  "SCHD_ADJ_WORKLOAD4"=>nil
#  
#  # Are these LEVL1_CODE1,2,3,4 related to SCHD_CODE1,2,3,4?
#  # Do they go together? no
#  "LEVL_CODE1"=>"GR",
#  "LEVL_DESC1"=>"Graduate Level - Qtr.",
# 
#  "LEVL_CODE2"=>"L0",
#  "LEVL_DESC2"=>"Law School Level - Qtr.",
# 
#  "LEVL_CODE3"=>"MD",
#  "LEVL_DESC3"=>"Medical Level - Qtr.",
# 
#  "LEVL_CODE4"=>"ND",
#  "LEVL_DESC4"=>"Non-Degree Level - Qtr.",
# }