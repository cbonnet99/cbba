role :app, "75.101.132.186"
role :web, "75.101.132.186"
role :db, "75.101.132.186", :primary => true
set :user,          "cyrille"
set :runner,        "cyrille"
set :password,  "mavslr55"
set :deploy_to, "/var/rails/be_amazing_staging"
set :rails_env, :staging
set :db_user, "bam_user"
set :db_name, "be_amazing_staging"
set :db_password, "test0user"