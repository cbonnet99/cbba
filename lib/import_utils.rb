require 'csv'
require 'graticule'
require 'active_record/fixtures'

class ImportUtils

  def self.strip_and_nil(str)
    if str.nil?
      ""
    else
      str.strip
    end
  end

	def self.import_districts
		parsed_file = CSV::Reader.parse(File.open(File.dirname(__FILE__) + "/../csv/districts.csv"))
		parsed_file.each  do |row|
			region_str = row[0]
			district_str = row[1]
			region = Region.find_or_create_by_name(region_str)
			District.find_or_create_by_name_and_region_id(district_str, region.id)
		end
	end

  def self.import_counters
    directory = File.join( File.dirname(__FILE__) , '../test/fixtures' )
    Fixtures.create_fixtures(directory, 'counters')
  end

  def self.import_categories
    directory = File.join( File.dirname(__FILE__) , '../test/fixtures' )
    Fixtures.create_fixtures(directory, 'categories')
  end

  def self.import_subcategories
    directory = File.join( File.dirname(__FILE__) , '../test/fixtures' )
    Fixtures.create_fixtures(directory, 'subcategories')
  end

  #returns a location object for the address passed as a parameter
  def self.geocode(address)
    #TODO: remove hardocded Google Maps API key for BAM
    geocoder = Graticule.service(:google).new "ABQIAAAAEUGw4om-AL6FPqaNLiT02xTtdy7lWpREaOTRxKljyUIPkk9sUhRgjCWR1VVeuR_sNL62bGyg47HMUw"
    return geocoder.locate(address)
  end

  def self.geocode_users(csv_file="users.csv")
    success = 0
    errors = 0
    CSV.open(File.dirname(__FILE__) + "/../csv/geocoded_#{csv_file}", 'w') do |writer|
      CSV.open(File.dirname(__FILE__) + "/../csv/#{csv_file}", 'r')  do |row|
        address1 = ImportUtils.strip_and_nil(row[5])
        suburb = ImportUtils.strip_and_nil(row[6])
        district_str = ImportUtils.strip_and_nil(row[7])
        region_str = ImportUtils.strip_and_nil(row[8])
        unless address1.blank? && suburb.blank?
          arr = []
          arr << address1 unless address1.blank?
          arr << suburb unless suburb.blank?
          arr << district_str unless district_str.blank?
          arr << "New Zealand"
          req_str = arr.join(", ")
          puts "Locating: #{req_str}"
          begin
            location = ImportUtils.geocode(req_str)
            puts "Found: #{location.inspect}"
            success += 1
            latitude = location.latitude
            longitude = location.longitude
            row << latitude
            row << longitude
          rescue Graticule::AddressError
            errors += 1
            puts "Address error"
          end
        end
        writer << row
      end
      puts "===== Successfully geocoded #{success} users. Address error on #{errors} users"
    end
  end

	def self.import_users(csv_file="users.csv")
		parsed_file = CSV::Reader.parse(File.open(File.dirname(__FILE__) + "/../csv/#{csv_file}"))
		User.transaction do
			Category.transaction do
				free_listing = Role.find_or_create_by_name("free_listing")
				full_member = Role.find_or_create_by_name("full_member")
				user_count = 0
				parsed_file.each  do |row|
					first_name = ImportUtils.strip_and_nil(row[0])
					last_name = ImportUtils.strip_and_nil(row[1])
					business_name = ImportUtils.strip_and_nil(row[4])
					address1 = ImportUtils.strip_and_nil(row[5])
					suburb = ImportUtils.strip_and_nil(row[6])
					district_str = ImportUtils.strip_and_nil(row[7])
					region_str = ImportUtils.strip_and_nil(row[8])
					phone_array = ImportUtils.decompose_phone_number(ImportUtils.strip_and_nil(row[9]))
					mobile_array = ImportUtils.decompose_mobile_number(ImportUtils.strip_and_nil(row[10]))
					email = ImportUtils.strip_and_nil(row[11])
          category_str = ImportUtils.strip_and_nil(row[12])
					subcategory_str = ImportUtils.strip_and_nil(row[13])
					role_str = ImportUtils.strip_and_nil(row[15])
					if role_str == "2"
						role = full_member
					else
						role = free_listing
					end
					receive_newsletter_str = ImportUtils.strip_and_nil(row[17])
					receive_newsletter = (receive_newsletter_str =="Yes")

          latitude = ImportUtils.strip_and_nil(row[18])
          longitude = ImportUtils.strip_and_nil(row[19])
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
#					category = Category.find_or_create_by_name("All")
					subcategory = Subcategory.find_or_create_by_name_and_category_id(subcategory_str.strip.capitalize, category.id)
					user = User.new(:first_name => first_name, :last_name => last_name, :business_name => business_name,
						:address1 => address1, :suburb => suburb, :district_id => district.id,
						:region_id => region.id, :phone_prefix => phone_array[0], :phone_suffix => phone_array[1], :mobile_prefix => mobile_array[0], :mobile_suffix => mobile_array[1], :email => email,
						:free_listing => (role == free_listing), :professional => true,
						:password => "blablabla", :password_confirmation => "blablabla",
            :subcategory1_id => subcategory.id, :category_id => category.id,
						:receive_newsletter => receive_newsletter, :membership_type => role == full_member ? "full_member" : "free_listing",
            :latitude => latitude, :longitude => longitude )
					user.register!
					user.activate!
          # #publish profile
          user.user_profile.publish!
					puts "Added user #{user.name}"
					user_count += 1
				end
				puts "Added #{user_count} users"
			end
		end
	end

  def self.decompose_phone_number(number_str)
    if number_str.blank?
      return number_str
    else
      number_str.gsub!(/ /, '').gsub!(/-/, '')
      return [number_str[0,2], number_str[2,number_str.size]]
    end
  end

  def self.decompose_mobile_number(number_str)
    if number_str.blank?
      return number_str
    else
      number_str.gsub!(/ /, '').gsub!(/-/, '')
    return [number_str[0,3], number_str[3,number_str.size]]
    end
  end
end