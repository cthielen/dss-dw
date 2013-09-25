# set :output, "/path/to/my/cron_log.log"
#
every 8.hours do
  #command "/usr/bin/some_great_command"
  #runner "MyModel.some_method"
  #rake "some:great:rake:task"
  envcommand 'bundle exec rake banner:import'
end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
