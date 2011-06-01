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
			puts "Creating district #{district_str} in region #{region_str}"
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

  def self.import_roles
    directory = File.join( File.dirname(__FILE__) , '../test/fixtures' )
    Fixtures.create_fixtures(directory, 'roles')
  end

  def self.import_charities
    directory = File.join( File.dirname(__FILE__) , '../test/fixtures' )
    Fixtures.create_fixtures(directory, 'charities')
  end

  def self.import_subcategories
    directory = File.join( File.dirname(__FILE__) , '../test/fixtures' )
    Fixtures.create_fixtures(directory, 'subcategories')
    #remove resident experts
    Subcategory.with_resident_expert.each do |s|
      s.resident_expert_id = nil
      s.save
    end
  end

	def self.import_users(csv_file="users.csv")
	  nz = Country.find_by_country_code("nz")
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
					phone = ImportUtils.strip_and_nil(row[9])
					mobile = ImportUtils.strip_and_nil(row[10])
					email = ImportUtils.strip_and_nil(row[11])
          website = ImportUtils.strip_and_nil(row[12])

          category1_str = ImportUtils.strip_and_nil(row[13])
					subcategory1_str = ImportUtils.strip_and_nil(row[14])
          category2_str = ImportUtils.strip_and_nil(row[15])
					subcategory2_str = ImportUtils.strip_and_nil(row[16])
          category3_str = ImportUtils.strip_and_nil(row[17])
					subcategory3_str = ImportUtils.strip_and_nil(row[18])

          member_until_str = ImportUtils.strip_and_nil(row[19])
          member_since_str = ImportUtils.strip_and_nil(row[20])
          member_until = member_since = nil
          member_until = DateTime.strptime(member_until_str, "%d.%m.%Y") unless member_until_str.blank?
          member_since = DateTime.strptime(member_since_str, "%d.%m.%Y") unless member_since_str.blank?
          
					role_str = ImportUtils.strip_and_nil(row[21])
					if role_str == "2"
						role = full_member
					else
						role = free_listing
					end
					receive_newsletter_str = ImportUtils.strip_and_nil(row[23])
					receive_newsletter = (receive_newsletter_str =="Yes")

          latitude = ImportUtils.strip_and_nil(row[24])
          longitude = ImportUtils.strip_and_nil(row[25])
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
          category1_id = nil
          subcategory1_id = nil
          unless category1_str.blank?
            category1 = Category.find_by_name(category1_str.strip.capitalize)
            if category1.nil?
              puts "ERROR! importing category1: #{category1_str.strip.capitalize}"
            else
              category1_id = category1.id
              subcategory1 = Subcategory.find_by_name_and_category_id(subcategory1_str, category1_id)
              if subcategory1.nil?
                puts "ERROR! importing subcategory1: #{subcategory1_str}"
              else
                subcategory1_id = subcategory1.id
              end
            end
          end
          subcategory2_id = nil
          unless category2_str.blank?
            category2 = Category.find_by_name(category2_str.strip.capitalize)
            if category2.nil?
              puts "ERROR! importing category2: #{category2_str.strip.capitalize}"
            else
              category2_id = category2.id
              subcategory2 = Subcategory.find_by_name_and_category_id(subcategory2_str, category2_id)
              if subcategory2.nil?
                puts "ERROR! importing subcategory2: #{subcategory2_str}"
              else
                subcategory2_id = subcategory2.id
              end
            end
          end
          subcategory3_id = nil
          unless category3_str.blank?
            category3 = Category.find_by_name(category3_str.strip.capitalize)
            if category3.nil?
              puts "ERROR! importing category3: #{category3_str.strip.capitalize}"
            else
              category3_id = category3.id
              subcategory3 = Subcategory.find_by_name_and_category_id(subcategory3_str, category3_id)
              if subcategory3.nil?
                puts "ERROR! importing subcategory3: #{subcategory3_str}"
              else
                subcategory3_id = subcategory3.id
              end
            end
          end
					user = User.new(:country_id => nz.id, :first_name => first_name, :last_name => last_name, :business_name => business_name,
						:address1 => address1, :suburb => suburb, :district_id => district.id,
						:region_id => region.id, :phone => phone, :mobile => mobile, :email => email,
						:free_listing => (role == free_listing), :professional => true,
						:password => "blablabla", :password_confirmation => "blablabla",
            :subcategory1_id => subcategory1_id,
            :subcategory2_id => subcategory2_id,
            :subcategory3_id => subcategory3_id,
						:receive_newsletter => receive_newsletter, :membership_type => role == full_member ? "full_member" : "free_listing",
            :latitude => latitude, :longitude => longitude, :website => website, :accept_terms => true
            )
					user.save!
					user.confirm!
					
          # #publish profile
          user.user_profile.publish!
          user.member_until = member_until
          user.member_since = member_since
          user.save!
					puts "Added user number #{user_count}: #{user.name}"
					user_count += 1
				end
				puts "Added #{user_count} users"
			end
		end
	end

end