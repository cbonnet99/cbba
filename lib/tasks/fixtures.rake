require 'config/environment'

namespace :db do
  namespace :fixtures do
    fixtures_path = RAILS_ROOT + '/db/fixtures'
    fixtures_path << '/' + ENV['FIXTURES'] if ENV['FIXTURES']
    puts fixtures_path

    unless File.exist?(fixtures_path)
      Dir.mkdir fixtures_path
    end

    desc "Import fixtures from db/fixtures into database"
    task :import do
      require 'active_record/fixtures'

      Rake::Task["db:recreate"].invoke

      files = Dir.glob(fixtures_path + '/*.yml')
      files.each do |file|
        table = File.basename(file, File.extname(file))

        if File.size(file) > (1024*1024)
          tmp = File.read(file)
          tmp = tmp.split(/^\w+:/)
          tmp.reject!{|t| t =~ /^---/ }

          puts "Importing #{tmp.length} fixtures into #{table}"
          tmp.each do |t|
            fixture = Fixture.new(YAML::load(t), table.classify)
            ActiveRecord::Base.connection.execute "INSERT INTO #{table} (#{fixture.key_list}) VALUES (#{fixture.value_list})", 'Fixture Insert'
          end
        else
          puts "Importing #{File.basename(file, File.extname(file)).humanize}"
          Fixtures.create_fixtures(fixtures_path, table)
        end
      end

      Rake::Task['tmp:cache:clear'].invoke
    end

    desc 'Create YAML test fixtures from data in an existing database.
    Defaults to development database.  Set RAILS_ENV to override.'
    task :dump => :environment do
      sql  = "SELECT * FROM %s"
      skip_tables = ["schema_info"]
      ActiveRecord::Base.establish_connection(:development)
      (ActiveRecord::Base.connection.tables - skip_tables).each do |table_name|
        i = "000"
        File.open("#{RAILS_ROOT}/test/fixtures/#{table_name}.yml", 'w') do |file|
          data = ActiveRecord::Base.connection.select_all(sql % table_name)
          file.write data.inject({}) { |hash, record|
            hash["#{table_name}_#{i.succ!}"] = record
            hash
          }.to_yaml
        end
      end
    end
	end
end