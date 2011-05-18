class AddGstToCountry < ActiveRecord::Migration
  def self.up
    add_column :countries, :gst, :boolean, :default => false
    nz = Country.find_by_country_code("nz")
    nz.update_attribute(:gst, true) 
  end

  def self.down
    remove_column :countries, :gst
  end
end
