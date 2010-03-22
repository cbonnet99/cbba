module ActiveRecord
  class Base
      
    def update_attribute_without_timestamping(attr_sym, value)
      class << self
        def record_timestamps; false; end
      end
      
      update_attribute(attr_sym, value)
      
      class << self
        remove_method :record_timestamps
      end
    end
    
  end
end