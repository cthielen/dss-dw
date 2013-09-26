job_type :envcommand, 'cd :path && RAILS_ENV=:environment :task'

# set :output, "/path/to/my/cron_log.log"
#
every 8.hours do
  #command "/usr/bin/some_great_command"
  #runner "MyModel.some_method"
  rake "banner:import"
  #envcommand 'bundle exec rake banner:import'
end

every 4.hours do
  rake "iam:import"
end

# Learn more: http://github.com/javan/whenever
# pid, size = `ps ax -o pid,rss | grep -E "^[[:space:]]*#{$$}"`.strip.split.map(&:to_i)
