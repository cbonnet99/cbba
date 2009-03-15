module ContactSystem
  def self.included(base)
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
end
