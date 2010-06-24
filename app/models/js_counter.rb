class JsCounter < ActiveRecord::Base
  def self.subcats
    JsCounter.find_by_name("subcats")
  end
  def self.regions
    JsCounter.find_by_name("regions")
  end
  # def self.subcats_last_updated_at
  #   self.subcats.try(:updated_at)
  # end
  # def self.regions_last_updated_at
  #   self.regions.try(:updated_at)
  # end
  def self.set_subcats(new_timestamp)
    if self.subcats.nil?
      JsCounter.create(:name => "subcats", :value => new_timestamp )
    else
      JsCounter.subcats.update_attribute(:value, new_timestamp )
    end
  end
  def self.subcats_value
    self.subcats.try(:value)
  end
  
end
