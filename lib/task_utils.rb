class TaskUtils

  def self.rotate_user_positions_in_subcategories
    Subcategory.all.each do |sub|
      s_users = sub.subcategories_users.find(:all, :include => "user", :conditions => "users.free_listing is false")
#      s_users = SubcategoriesUser.find_by_sql("select su.* from subcategories_users su, users u where su.subactegsu.user_id = u.id and u.free_listing is false order by su.position")
      #if there is only 1, no rotation is needed
#      puts "========= s_users before: #{s_users.inspect}"
      unless s_users.empty? || s_users.size <= 1
        first = s_users.first
        pos = 1
        s_users.each do |su|
#          puts "====== su: #{su.inspect}"
          if su != first
#            puts "====== setting to: #{pos}"
            su.update_attribute(:position, pos)
            pos += 1
          end
        end
        #put first at the end
        first.update_attribute(:position, pos)
      end
#      puts "========= s_users after: #{s_users.inspect}"
    end    
  end

	def self.count_users
		Category.all.each do |c|
			c.update_attribute(:users_counter, User.count_all_by_subcategories(*c.subcategories))
		end
		Subcategory.all.each do |s|
			s.update_attribute(:users_counter, User.count_all_by_subcategories(s))
		end
	end

#  def self.create_default_roles
#    YAML::load(ERB.new(IO.read(File.dirname(__FILE__) +"/../test/fixtures/roles.yml")).result)
#  end

  #better to call after the exisitg users have been imported (because Norma, Julie, etc. will
  #be listed there as practicioners)
  def self.create_default_admins
    admin_role = Role.find_or_create_by_name("admin")
    default_district = District.find_by_name("Wellington City")
    $admins.each do |admin|
      user = User.find_by_email(admin[:email])
      if user.nil?
        user = User.new(:first_name => admin[:first_name], :last_name => admin[:last_name],
          :email => admin[:email],
          :professional => true,
          :password => "monkey", :password_confirmation => "monkey",
          :receive_newsletter => false, :district_id => default_district.id  )
        if user && user.valid?
          user.register!
          user.activate!
          user.add_role("admin")
        else
          puts "Could not create user #{admin[:email]}, because of errors:"
          user.errors.full_messages.each do |m|
            puts "* #{m}"
          end
        end
      else
        user.add_role("admin")
      end
    end
  end
end