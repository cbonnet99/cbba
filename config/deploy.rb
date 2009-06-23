# Elastic Server Deployment Script
# Author: Yan Pritzker, CohesiveFT <yan.pritzker@cohesiveft.com>
# Revision: 1.1
# Requires: Capistrano 2.3
#
# CHANGELOG
#
# Version 1.1:
#	Working with cap 2.3, default deploy from local copy
#
# Version 1.0:
#	Initial revision, for cap 2.0
#

# If you wish to deploy with something other than the current
# directory please modify the settings below
#

#  set :repository,    "[repository goes here]"
#  set :scm_username,  "[username goes here]"
#  set :scm_password,  lambda { CLI.password_prompt "SVN Password (user: #{scm_username}): "}
#  set :scm, :subversion
#  set :deploy_via,  :copy
#  set :copy_strategy, :export

set :scm_username,  "cbonnet99@gmail.com"
#set :scm_password,  lambda { CLI.password_prompt "SVN Password (user: #{scm_username}): "}
set :deploy_via, :remote_cache
# set :deploy_via,  :copy
set :scm, :git
#set :repository, "git://github.com/cbonnet99/cbba.git"
set :repository, "git@github.com:cbonnet99/cbba.git"
set :branch, "master"
ssh_options[:forward_agent] = true

#set :repository, "."
#set :scm, :none
#set :deploy_via, :copy

# This script is designed to prompt you for the ip of your Elastic Server.
# You can hardcode it by changing the :deploy_to_ip variable.

set :deploy_to_ip,  "75.101.132.186"
#set :deploy_to_ip,  lambda { HighLine.new.ask "Elastic Server IP: "}
set :user,          "cftuser"
set :runner,        "cftuser" # required for cap 2.3
#set :password,      "cftuser"  #
set :password,  "wwu5Airemo"
#set :password,  lambda { CLI.password_prompt "Target Password (user: #{user}): "}

# DO NOT MODIFY BELOW THIS LINE UNLESS YOU KNOW WHAT YOU'RE DOING

set :deploy_to, "/usr/local/cft/deploy/capistrano"
set :elastic_server_deploy_target, "/usr/local/cft/deploy/rails"

role :app, deploy_to_ip
role :web, deploy_to_ip
role :db, deploy_to_ip, :primary => true

before "deploy:init", "deploy:setup"
after 'deploy:update_code', 'deploy:symlink_shared'

#after "deploy:symlink", "deploy:elastic_server_symlink"

# NOTE: This deployment script relies on calling Elastic Server rubberbands
# which control the server (mongrel, etc) that lives in /etc/cft.d/mods-enabled
#
# In a future version, the commands will be performed via webservice.
#

namespace(:bam) do
  desc "Import existing users"
  task :import_users, :roles => :app do
    run "cd #{release_path} && rake bam:import_users RAILS_ENV=production"    
  end
     
  desc "Regenerates JS files after a new subcategory or location has been added"
  task :regenerates_js, :roles => :app do
    run "cd #{release_path} && rake bam:generate_autocomplete_js RAILS_ENV=production"    
    run "cd #{release_path} && rake asset:packager:build_all RAILS_ENV=production"    
  end
  
end

namespace(:rails_server) do
  desc "start the app server"
  task :start, :roles => :app do
    sudo "touch #{current_path}/tmp/restart.txt"    
  end

  desc "stop the app server"
  task :stop, :roles => :app do
  end


  desc "restart the app server"
  task :restart, :roles => :app do
    sudo "touch #{current_path}/tmp/restart.txt"    
  end
end

namespace(:deploy) do
  desc "Copy all cron jobs"
  task :cron do
    if (ENV['RAILS_ENV'] || '').downcase == 'production'
	    cron_app
	    cron_db
    else
	    puts "*** No cron jobs deployed as it is not a production environment"
    end
  end

  desc "Copy cron jobs for application servers"
  task :cron_app, :roles => :app do
    Dir.foreach("cron_jobs/app") do |dir|
	    if ![".", ".."].include?(dir)
        Dir.foreach("cron_jobs/app/"+dir) do |file|
          if ![".", ".."].include?(file)
            run "#{sudo} cp #{current_path}/cron_jobs/app/#{dir}/#{file} /etc/#{dir}/#{file}"
            run "#{sudo} chmod 0755 /etc/#{dir}/#{file}"
          end
        end
	    end
    end
  end

  desc "Copy cron jobs for database servers"
  task :cron_db, :roles => :db do
    Dir.foreach("cron_jobs/db") do |dir|
	    if ![".", ".."].include?(dir)
        Dir.foreach("cron_jobs/db/"+dir) do |file|
          if ![".", ".."].include?(file)
            run "#{sudo} cp #{current_path}/cron_jobs/db/#{dir}/#{file} /etc/#{dir}/#{file}"
            run "#{sudo} chmod 0755 /etc/#{dir}/#{file}"
          end
        end
	    end
    end
  end

  desc "Restart the Rails server."
  task :restart, :roles => :app do
    rails_server.restart
  end

  desc "Symlink shared configs and folders on each release."
  task :symlink_shared do
    if Dir["#{shared_path}/assets"].nil?
      run "mkdir #{shared_path}/assets"
    end
    run "ln -nfs #{shared_path}/assets #{release_path}/public/assets"
  end

  desc "Initialize APT packages"
  task :run_init_packages do
    run "#{sudo} apt-get update"
    run "#{sudo} apt-get install -y imagemagick"
    run "#{sudo} apt-get install -y git-core"
    run "#{sudo} apt-get install -y build-essential"
    run "#{sudo} apt-get install -y libxml2-dev"
    run "#{sudo} gem install libxml-ruby"
  end
  desc "Run init script for AMIs"
  task :run_init_ami do
    run "#{sudo} chmod +x #{current_path}/script/init_*.sh"
    run "#{sudo} ln -s /etc/apache2/mods-available/expires.load /etc/apache2/mods-enabled/expires.load"
    run "#{sudo} ln -s /etc/apache2/mods-available/ssl.load /etc/apache2/mods-enabled/ssl.load"
    run "#{sudo} ln -s /etc/apache2/mods-available/ssl.conf /etc/apache2/mods-enabled/ssl.conf"
    run "#{sudo}  ln -s /etc/apache2/mods-available/headers.load /etc/apache2/mods-enabled/headers.load"
    run "#{sudo} #{current_path}/script/init_ami.sh"
    run "#{sudo} #{current_path}/script/init_ami_postgres.sh"
    run "#{sudo} #{current_path}/script/init_assets.sh"
    run "#{sudo} #{current_path}/script/init_bash_profile.sh"
  end

  desc "Installs gems necessary for BAM"
  task :install_gems do
    run("cd #{deploy_to}/current && #{sudo} rake gems:install")
#    run("cd #{deploy_to}/current && #{sudo} rake gems:unpack:dependencies")
#    run("cd #{deploy_to}/current && #{sudo} rake gems:build")
  end

  desc "Load test data"
  task :load_data do
    #Cyrille(7 Dev 2008): commented out for now as we use test data in staging
#    unless ENV["RAILS_ENV"] == "production"
    run("cd #{deploy_to}/current; /usr/bin/rake bam:load RAILS_ENV=production")
#    end
  end

  task :after_update_code, :roles => [:app] do
    run "cd #{release_path} && rake bam:generate_autocomplete_js RAILS_ENV=production"
    run "cd #{release_path} && rake asset:packager:build_all RAILS_ENV=production"
  end

  desc "Installs gems necessary for BAM"
  task :install_gems do

  end
  
  desc "Initializes BAM site"
  task :init do
    transaction do
      run_init_packages
      update_code
      web.disable
      cron
      symlink
      elastic_server_symlink
      run_init_ami
      install_gems
      migrate
      load_data
    end

    restart
    web.enable
  end

  desc "Deploy will throw up the maintenance.html page and run migrations then it restarts and enables the site again."
  task :default do
    transaction do
      update_code
      web.disable
      cron
      symlink
      elastic_server_symlink
#      run_init_ami
      migrate
#      load_data
    end

    restart
    web.enable
  end

  desc "Creates a symlink in order for proper deployment on Elastic Server"
  task :elastic_server_symlink do
    run "rm -rf #{elastic_server_deploy_target}"
    run "ln -nfs #{current_path} #{elastic_server_deploy_target}"
  end
end
