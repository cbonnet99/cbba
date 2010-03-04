role :app, "www.beamazing.co.nz"
role :web, "www.beamazing.co.nz"
role :db, "www.beamazing.co.nz", :primary => true
set :user,          "cyrille"
set :runner,        "cyrille"
set :password,  "mavslr55"
set :deploy_to, "/var/rails/be_amazing"
set :rails_env, :production
set :db_user, "postgres"
set :db_name, "be_amazing_production"
set :db_password, "test0user"