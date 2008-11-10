require 'csv'

class ImportUtils
	def self.import_districts
		parsed_file = CSV::Reader.parse(File.dirname(__FILE__) + "/../csv/districts.csv", "\r", "," )
		puts "parsed_file: #{parsed_file.inspect}"
		parsed_file.each  do |row|
			region = row[1]
			district = row[2]
			puts region
			puts district
		end
	end
end