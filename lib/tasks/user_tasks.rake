require 'rake'

namespace :user do
  namespace :api do
    desc 'Create an API user'
    task :create, :name do |t, args|
      Rake::Task['environment'].invoke

      unless args[:name]
        puts "Usage:\n\trake user:api:create[api_key_name]"
        exit
      end

      Authorization.ignore_access_control(true)
      
      u = ApiKeyUser.new
      u.name = args[:name]
      
      begin
        u.save!
      rescue Exception => e
        puts "Error: #{e.to_s}"
        exit
      end
      
      puts "Created.\n\tName  : #{u.name}\n\tSecret: #{u.secret}"
      
      Authorization.ignore_access_control(false)
    end

    desc 'Delete an API user'
    task :delete, :name do |t, args|
      Rake::Task['environment'].invoke
      
      unless args[:name]
        puts "Usage:\n\trake user:api:delete[api_key_name]"
        exit
      end

      Authorization.ignore_access_control(true)
      
      begin
        u = ApiKeyUser.find_by_name(args[:name])
      rescue Exception => e
        puts "Error: #{e.to_s}"
        exit
      end

      if u.nil?
        puts "No such API key user."
        exit
      end
      
      u.destroy
      
      puts "Deleted."
      
      Authorization.ignore_access_control(false)
    end

    desc 'List all API users'
    task :list do
      Rake::Task['environment'].invoke
      
      ApiKeyUser.all.each do |user|
        puts "'#{user.name}' last seen '#{user.logged_in_at ? user.logged_in_at : 'never'}'"
      end
      
      puts "#{ApiKeyUser.count} total API key users."
    end
  end
end
