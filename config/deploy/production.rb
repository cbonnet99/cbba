role :app, "174.129.33.107"
role :web, "174.129.33.107"
role :db, "174.129.33.107", :primary => true
set :user,          "cyrille"
set :runner,        "cyrille"
set :password,  "mavslr55"
set :deploy_to, "/var/rails/be_amazing"
set :rails_env, :production
set :db_user, "postgres"
set :db_name, "be_amazing_production"
set :db_password, "test0user"

# role :app, "75.101.132.186"
# role :web, "75.101.132.186"
# role :db, "75.101.132.186", :primary => true
# #set :deploy_to_ip,  lambda { HighLine.new.ask "Elastic Server IP: "}
# set :user,          "cftuser"
# set  :app_group,    "mongrel"
# set :app_user,      "cftuser"
# set :runner,        "cftuser" # required for cap 2.3
# #set :password,      "cftuser"  #
# set :password,  "mavslr55"
# set :deploy_to, "/usr/local/cft/deploy/capistrano"
# set :elastic_server_deploy_target, "/usr/local/cft/deploy/rails"
# set :rails_env, :production
# set :db_user, "postgres"
# set :db_name, "be_amazing_production"
# set :db_password, "test0user"