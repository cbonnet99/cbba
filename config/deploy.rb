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

set :repository, "."
set :scm, :none
set :deploy_via, :copy

# This script is designed to prompt you for the ip of your Elastic Server.
# You can hardcode it by changing the :deploy_to_ip variable.

set :deploy_to_ip,  lambda { HighLine.new.ask "Elastic Server IP: "}
set :user,          "cftuser"
set :runner,        "cftuser" # required for cap 2.3
#set :password,      "cftuser"  #
set :password,  lambda { CLI.password_prompt "Target Password (user: #{user}): "}

# DO NOT MODIFY BELOW THIS LINE UNLESS YOU KNOW WHAT YOU'RE DOING

set :deploy_to, "/usr/local/cft/deploy/capistrano"
set :elastic_server_deploy_target, "/usr/local/cft/deploy/rails"

role :app, deploy_to_ip
role :web, deploy_to_ip
role :db, deploy_to_ip, :primary => true

before "deploy", "deploy:setup"
after "deploy:symlink", "deploy:elastic_server_symlink"

# NOTE: This deployment script relies on calling Elastic Server rubberbands
# which control the server (mongrel, etc) that lives in /etc/cft.d/mods-enabled
#
# In a future version, the commands will be performed via webservice.
#
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
  desc "Restart the Rails server."
  task :restart, :roles => :app do
    rails_server.restart
  end

  desc "Long deploy will throw up the maintenance.html page and run migrations then it restarts and enables the site again."
  task :long do
    transaction do
      update_code
      web.disable
      symlink
      migrate
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
