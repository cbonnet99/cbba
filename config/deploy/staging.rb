role :app, "174.129.33.107"
role :web, "174.129.33.107"
role :db, "174.129.33.107", :primary => true
set :user,          "cyrille"
set :runner,        "cyrille"
set :password,  "mavslr55"
set :deploy_to, "/var/rails/be_amazing"
set :rails_env, :staging
set :db_user, "bam_user"
set :db_name, "be_amazing_staging"
set :db_password, "test0user"