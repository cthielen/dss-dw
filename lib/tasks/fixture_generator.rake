@fixtures = {}
@seen = {}

# Do something with a fixture.  In this case, we store it for later.
def handle_fixture(record)
  @fixtures[record.class.table_name] ||= []
  @fixtures[record.class.table_name] << record
end

# Get some sort of unique way of identifiying a record - class name and id.
def unique_record(record)
  return record.class.to_s + " " + record.id.to_s
end

# Grab all the relations of a class and add them to the queue.
def add_fixture(record)
  ur = unique_record(record)
  if @seen[ur]
    puts "LOOP!"
    return
  end
  @seen[ur] = true

  puts "Fixture for #{record.class.name} - ID #{record.id}"
  handle_fixture(record)
  record.class.reflections.each do |k, r|
    begin
      if r.macro == :has_many ||
          r.macro == :has_and_belongs_to_many
        related = record.send(r.name).send('find', :all, :limit => STARTING_LIMIT)
      else
        related = record.send(r.name)
      end
      related = [related] unless related.is_a?(Array)
      related.each do |related_record|
        if related_record
          puts "    New Record #{related_record.class.name} #{related_record.id}"
          @todo << related_record
        end
      end
    rescue => e
      puts "    ERROR: #{e}:\n#{e.backtrace.inspect}"
    end
  end
end

@todo = []

namespace :db do
  namespace :fixtures do
    desc 'Creates YAML fixtures from existing database contents'
    task :generate, [:model_name] => :environment do |t, args|
      if args[:model_name].nil?
        puts "Usage: rake db:fixtures:generate[ModelName]"
        exit
      end
      
      STARTING_CLASS = args[:model_name].constantize
      STARTING_FIND  = :all
      STARTING_LIMIT = 1000

      tmp = 0
      totale = STARTING_CLASS.find(STARTING_FIND, :limit => STARTING_LIMIT).size
      STARTING_CLASS.find(STARTING_FIND, :limit => STARTING_LIMIT).each do |m|
        tmp += 1
        puts "#{tmp} su #{totale}: #{m.id}"
        @todo << m
      end

      while true
        if @todo.length == 0
          break
        end
        add_fixture(@todo.pop)
      end

      puts "\n\n#{'='*80}\nScan Finished\n#{'='*80}\n\n"

      @fixtures.each do |name, fixture|
        if fixture.size > 0
          i = "000"
          filename = "#{Rails.root}/test/fixtures/#{name}.yml"
          puts "Create #{filename} for class #{fixture.class.name}"
          FileUtils.mkdir(File.dirname(filename)) unless Dir[File.dirname(filename)].size > 0
          File.open("#{Rails.root}/test/fixtures/#{name}.yml", 'w') do |file|
            file.write fixture.inject({}) { |hash, record|
              hash["#{record.class.table_name}_#{i.succ!}"] = record.attributes
              hash
            }.to_yaml
          end
        else
          puts "Fixture for #{name} is EMPTY"
        end
      end
    end
  end
end
