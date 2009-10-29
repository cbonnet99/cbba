module ContactSystem
  def self.included(base)
		base.send :extend, ContactSystemClassMethods
		base.send :include, ContactSystemInstanceMethods
	end
  
  module ContactSystemInstanceMethods
    def get_region_from_district
      unless self.district.nil?
        self.region = self.district.region
      end
    end
    
    def name
      "#{self.first_name} #{self.last_name}"
    end    
  end
  
  module ContactSystemClassMethods
    SPECIAL_CHARACTERS = ["!", "@", "#", "$", "%", "~", "^", "&", "*"]
    
    # Authenticates a user by their login name and unencrypted password.  Returns
    # the user or nil.
    #
    def authenticate(email, password)
      u = find_by_email(email)
      u && u.authenticated?(password) ? u : nil
    end
    
    def generate_random_password
      "#SPECIAL_CHARACTERS.rand}#{PasswordGenerator.generate(5).capitalize}#{rand(9)}#{rand(9)}"
    end
    
  end
end
