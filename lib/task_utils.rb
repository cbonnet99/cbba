class TaskUtils

  def self.rotate_user_positions_in_subcategories
    Subcategory.all.each do |sub|
      first = sub.subcategories_users.first
      unless first.nil?
        first.move_to_bottom
      end
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
    $admins.each do |admin|
      user = User.find_by_email(admin[:email])
      if user.nil?
        user = User.new(:first_name => admin[:first_name], :last_name => admin[:last_name],
          :email => admin[:email],
          :professional => true,
          :password => "monkey", :password_confirmation => "monkey",
          :receive_newsletter => false )
				user.register!
				user.activate!
        user.roles << admin_role
      else
        user.roles << admin_role
      end
    end
  end
end