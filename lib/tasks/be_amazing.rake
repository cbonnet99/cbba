namespace :bam do

  desc "Geocodes all users from CSV (Warning: this is calling Google Maps)"
  task :geocode => :environment do
			ImportUtils.geocode_users
  end

  desc "Loads all users and districts in the current database"
  task :load => :environment do
			ImportUtils.import_districts
      TaskUtils.create_default_admins
			TaskUtils.count_users
			TaskUtils.mark_down_old_full_members
  end

  desc "Loads all users and districts in the current database"
  task :load_demo_data => :environment do
			ImportUtils.import_districts
			ImportUtils.import_users
      TaskUtils.create_default_admins
			TaskUtils.count_users
			TaskUtils.mark_down_old_full_members
  end

  desc "Loads all GEOCODED users and districts in the current database"
  task :load_geocoded => :environment do
			ImportUtils.import_districts
			ImportUtils.import_users("geocoded_users.csv")
      TaskUtils.create_default_admins
			TaskUtils.count_users
			TaskUtils.mark_down_old_full_members
  end

	desc "Recreates the database and reloads all users and districts (can only be used in dev, as it sends email to new users)"
	task :reload => :environment do
		if ENV["RAILS_ENV"].blank? || ENV["RAILS_ENV"] == "development"
			Rake::Task["db:drop"].invoke
			Rake::Task["db:create"].invoke
			Rake::Task["db:migrate"].invoke
			Rake::Task["bam:load"].invoke
		else
      if ENV["RAILS_ENV"] == "test"
        Rake::Task["db:drop"].invoke
        Rake::Task["db:create"].invoke
        Rake::Task["db:migrate"].invoke
      else
        puts "Sorry, you can not use this in #{ENV["RAILS_ENV"]}, only in development"
      end
		end
	end

	desc "Recreates the database and reloads all GEOCODED users and districts (can only be used in dev, as it sends email to new users)"
	task :reload_geocoded => :environment do
		if ENV["RAILS_ENV"].blank? || ENV["RAILS_ENV"] == "development"
			Rake::Task["db:drop"].invoke
			Rake::Task["db:create"].invoke
			Rake::Task["db:migrate"].invoke
			Rake::Task["bam:load_geocoded"].invoke
		else
      if ENV["RAILS_ENV"] == "test"
        Rake::Task["db:drop"].invoke
        Rake::Task["db:create"].invoke
        Rake::Task["db:migrate"].invoke
      else
        puts "Sorry, you can not use this in #{ENV["RAILS_ENV"]}, only in development"
      end
		end
	end

end
