namespace :bam do
	desc "Reloads all users and districts (can only be used in dev, as it sends email to new users)"
	task :reload => :environment do
		if ENV["RAILS_ENV"].blank? || ENV["RAILS_ENV"] == "development"
			Rake::Task["db:drop"].invoke
			Rake::Task["db:create"].invoke
			Rake::Task["db:migrate"].invoke
			ImportUtils.import_districts
			ImportUtils.import_users
      TaskUtils.create_default_admins
			TaskUtils.count_users
		else
			puts "Sorry, you can not use this in #{ENV["RAILS_ENV"]}, only in development"
		end
	end
end
