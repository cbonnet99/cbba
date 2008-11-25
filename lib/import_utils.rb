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
		User.transaction do
			Category.transaction do
				free_listing = Role.find_or_create_by_name("free_listing")
				full_member = Role.find_or_create_by_name("full_member")
				user_count = 0
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
					category_str = row[12]
					subcategory_str = row[13]
					role_str = row[15]
					if role_str == "2"
						role = full_member
					else
						role = free_listing
					end
					receive_newsletter_str = row[17]
					receive_newsletter = (receive_newsletter_str =="Yes")
					region = Region.find_by_name(region_str)
					if region.nil?
						raise "Error: region #{region_str} could not be found"
						puts "No user was added"
					end
					district = District.find_by_name_and_region_id(district_str, region.id)
					if district.nil?
						raise "Error: district #{district_str} could not be found"
						puts "No user was added"
					end
					category = Category.find_or_create_by_name(category_str.strip.capitalize)
					subcategory = Subcategory.find_or_create_by_name_and_category_id(subcategory_str.strip.capitalize, category.id)
					user = User.new(:first_name => first_name, :last_name => last_name, :business_name => business_name,
						:address1 => address1, :suburb => suburb, :district_id => district.id,
						:region_id => region.id, :phone => phone, :mobile => mobile, :email => email,
						:free_listing => (role == free_listing),
						:password => "blablabla", :password_confirmation => "blablabla",
						:receive_newsletter => receive_newsletter )
					user.register!
					user.activate!
					user.roles << role
					user.subcategories << subcategory
					puts "Added user #{user.name}"
					user_count += 1
				end
				puts "Added #{user_count} users"
			end
		end
	end
end