namespace :bam do
  
    task :generate_autocomplete_js => :environment do
      File.open("#{RAILS_ROOT}/public/javascripts/subcategories.js", 'w') do |out|
        subcategories = Subcategory.find(:all, :order =>:name)
        subcategories.concat(Category.find(:all, :order =>:name))
        out << "var sbg=new Array(#{subcategories.size});"
        subcategories.each_with_index do |subcategory, index|
          out << "sbg[#{index}]='#{subcategory.name}';"
        end
      end
      File.open("#{RAILS_ROOT}/public/javascripts/regions.js", 'w') do |out|
        regions = Region.find(:all, :order => "name" )
        districts = District.find(:all, :order => "name" )
        locations = regions + districts
        out << "var lts = new Array(#{locations.size});"
        locations.each_with_index do |location, index|
          out << "lts[#{index}]='#{location.name}';"
        end
      end
    end
  
  
  desc "Geocodes all users from CSV (Warning: this is calling Google Maps)"
  task :geocode => :environment do
			ImportUtils.geocode_users
  end

  desc "Import existing users"
  task :import_users => :environment do
			ImportUtils.import_users
			TaskUtils.count_users
			TaskUtils.update_counters
			TaskUtils.mark_down_old_full_members			
	end
	
  desc "Loads roles, districts, modalities, etc. in the current database"
  task :load => :environment do
			ImportUtils.import_roles
			ImportUtils.import_districts
			ImportUtils.import_counters
			ImportUtils.import_categories
			ImportUtils.import_subcategories
      TaskUtils.create_default_admins
			TaskUtils.count_users
			TaskUtils.update_counters
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
