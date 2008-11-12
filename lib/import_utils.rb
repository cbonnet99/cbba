require 'csv'

class ImportUtils
	def self.import_districts
		parsed_file = CSV::Reader.parse(File.open(File.dirname(__FILE__) + "/../csv/districts.csv"))
		parsed_file.each  do |row|
			region_str = row[0]
			district_str = row[1]
			region = Region.find_or_create_by_name(region_str)
			District.find_or_create_by_name_and_region_id(district_str, region.id)
		end
	end
	def self.import_users
		parsed_file = CSV::Reader.parse(File.open(File.dirname(__FILE__) + "/../csv/users.csv"))
		parsed_file.each  do |row|
			first_name = row[0]
			last_name = row[1]
			business_name = row[4]
			address1 = row[5]
			suburb = row[6]
			district_str = row[7]
			region_str = row[8]
			phone = row[9]
			mobile = row[10]
			email = row[11]
			category1_str = row[12]
			category2_str = row[13]
			category3_str = row[14]
			region = Region.find_by_name(region_str)
			if region.nil?
				puts "Error: region #{region_str} could not be found"
				break
			end
			district = District.find_by_name_and_region_id(district_str, region.id)
			if district.nil?
				puts "Error: district #{district_str} could not be found"
				break
			end
			category1 = Category.find_or_create_by_name(category1_str.capitalize)
			category2 = Category.find_or_create_by_name(category2_str.capitalize)
			category3 = Category.find_or_create_by_name(category3_str.capitalize)
			user = User.create(:first_name => first_name, :last_name => last_name, :business_name => business_name,
				:address1 => address1, :suburb => suburb, :district_id => district.id,
				:region => region.id, :phone => phone, :mobile => mobile, :email => email,
				:category1_id => category1.id, :category2_id => category2.id, :category3_id => category3.id )
			puts "Added user #{user.name}"
		end
	end
end