require 'capistrano/ext/multistage'
#require 'deprec'

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

set :application, "be_amazing"
set :scm_username,  "cbonnet99@gmail.com"
#set :scm_password,  lambda { CLI.password_prompt "SVN Password (user: #{scm_username}): "}
set :deploy_via, :remote_cache
# set :deploy_via,  :copy
set :scm, :git
#set :repository, "git://github.com/cbonnet99/cbba.git"
set :repository, "git@github.com:cbonnet99/cbba.git"
set :branch, "master"
ssh_options[:forward_agent] = true
default_run_options[:pty] = true

# =============================================================================
# DEPREC OPTIONS
# =============================================================================
set :ruby_vm_type,      :ree        # :ree, :mri
set :web_server_type,   :apache     # :apache, :nginx
set :app_server_type,   :passenger  # :passenger, :mongrel
set :db_server_type,    :postgresql      # :mysql, :postgresql, :sqlite

#set :packages_for_project, %w(build-essential libxml2-dev git-core ruby1.8-dev rubygems1.8 sun-java6-jre zip) # list of packages to be installed
set :gems_for_project, %w(SyslogLogger postgres libxml-ruby) # list of gems to be installed

#set :repository, "."
#set :scm, :none
#set :deploy_via, :copy

# This script is designed to prompt you for the ip of your Elastic Server.
# You can hardcode it by changing the :deploy_to_ip variable.

#set :password,  lambda { CLI.password_prompt "Target Password (user: #{user}): "}

# DO NOT MODIFY BELOW THIS LINE UNLESS YOU KNOW WHAT YOU'RE DOING



before "deploy:init", "deploy:setup"
after 'deploy:update_code', 'deploy:symlink_shared'

#after "deploy:symlink", "deploy:elastic_server_symlink"

after "deploy:symlink", "deploy:update_crontab"

namespace :bundler do
  task :create_symlink, :roles => :app do
    shared_dir = File.join(shared_path, 'bundle')
    release_dir = File.join(release_path, '.bundle')
    run("mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
  end

  task :install, :roles => :app do
    run "cd #{release_path} && bundle install"

    on_rollback do
      if previous_release
        run "cd #{previous_release} && bundle install"
      else
        logger.important "no previous release to rollback to, rollback of bundler:install skipped"
      end
    end
  end

  task :bundle_new_release, :roles => :db do
    bundler.create_symlink
    bundler.install
  end
end

after "deploy:rollback:revision", "bundler:install"
after "deploy:update_code", "bundler:bundle_new_release"

namespace(:bam) do
  desc "Import existing users"
  task :import_users, :roles => :app do
    run "cd #{release_path} && rake bam:import_users RAILS_ENV=production"    
  end
  
  desc "Restart HTTP accelerator"
  task :restart_varnish, :roles => :app do
    if rails_env == :production
      sudo "/etc/init.d/varnish restart"
    end
  end
  
     
  # desc "Regenerates JS files after a new subcategory or location has been added"
  # task :regenerates_js, :roles => :app do
  #   run "cd #{release_path} && rake bam:generate_autocomplete_js RAILS_ENV=production"
  #   run "cd #{release_path} && rake asset:packager:build_all RAILS_ENV=production"    
  # end
  
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
  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    if rails_env == :production
      puts "*** Deploying cron jobs"
      run "cd #{release_path} && whenever --update-crontab #{application}"
    else
      puts "*** No cron jobs deployed as the enviroment is NOT production, but #{rails_env}"
    end
  end
  
  desc "Restart the Rails server."
  task :restart, :roles => :app do
    rails_server.restart
  end

  desc "Symlink shared configs and folders on each release."
  task :symlink_shared do
    # unless File.directory?("#{shared_path}/assets")
    #   sudo "mkdir #{shared_path}/assets"
    # end
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
    run "#{sudo}  ln -sf ../usr/share/zoneinfo/Pacific/Auckland /etc/localtime"
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
    unless ENV["RAILS_ENV"] == "production"
      run("cd #{deploy_to}/current; /usr/bin/rake bam:load RAILS_ENV=staging")
    end
  end

  task :generate_assets, :roles => [:app] do
    run "cd #{release_path} && rake bam:generate_autocomplete_js RAILS_ENV=#{rails_env}"
    run "cd #{release_path} && rake asset:packager:build_all RAILS_ENV=#{rails_env}"
  end

  desc "Installs gems necessary for BAM"
  task :install_gems do

  end
  
  desc "Initializes BAM site"
  task :init do
    transaction do
      # run_init_packages
      update_code
      web.disable
      symlink
      # elastic_server_symlink
      # run_init_ami
      # install_gems
      migrate
      # load_data
      generate_assets
    end

    restart
    web.enable
    cleanup
  end

  desc "Deploy will throw up the maintenance.html page and run migrations then it restarts and enables the site again."
  task :default do
    transaction do
      update_code
      web.disable
      symlink
      # elastic_server_symlink
#      run_init_ami
      migrate
#      load_data
      generate_assets
    end

    restart
    web.enable
    bam.restart_varnish
    cleanup
  end

  desc "Creates a symlink in order for proper deployment on Elastic Server"
  task :elastic_server_symlink do
    run "rm -rf #{elastic_server_deploy_target}"
    run "ln -nfs #{current_path} #{elastic_server_deploy_target}"
  end
end
