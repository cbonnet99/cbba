class JsCounter < ActiveRecord::Base
  belongs_to :country
  
  def self.subcats(country)
    JsCounter.find_by_country_id_and_name(country.id, "subcats")
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
  def self.set_subcats(country, new_timestamp)
    if self.subcats(country).nil?
      JsCounter.create(:name => "subcats", :value => new_timestamp, :country_id => country.id)
    else
      JsCounter.subcats(country).update_attribute(:value, new_timestamp )
    end
  end
  def self.subcats_value(country)
    self.subcats(country).try(:value)
  end
  
end
