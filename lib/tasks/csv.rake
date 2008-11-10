require 'config/environment'

namespace :csv do

	desc "Imports all CSV files (or a particular file specified in CSV=xx)"
	task :import do
    fixtures_path = RAILS_ROOT + '/csv'
		csv_files = []
		if ENV['CSV']
			unless ENV['CSV'].end_with?(".csv")
				ENV['CSV'] += ".csv"
			end
			csv_files << ENV['CSV']
		else
			csv_files = Dir.glob(csv_path+'/*.csv')
		end
		csv_files.each do |file|
			parsed_file = CSV::Reader.parse(file)
			parsed_file.each  do |row|
				
			end
		end
	end
end