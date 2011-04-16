set :target_host, "ec2-175-41-159-245.ap-southeast-1.compute.amazonaws.com"
role :app, target_host
role :web, target_host
role :db, target_host, :primary => true
set :user,          "ec2-user"
set :runner,        "ec2-user"
# set :password,  "mavslr55"
set :deploy_to, "/var/rails/be_amazing"
set :rails_env, :production
set :db_user, "postgres"
set :db_name, "be_amazing_production"
set :db_password, "test0user"