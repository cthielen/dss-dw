job_type :envcommand, 'cd :path && RAILS_ENV=:environment :task'

every 8.hours do
  rake "banner:import"
end

every 4.hours do
  rake "iam:import"
end
