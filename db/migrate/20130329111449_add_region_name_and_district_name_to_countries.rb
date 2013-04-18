class AddRegionNameAndDistrictNameToCountries < ActiveRecord::Migration
  def self.up
    add_column :countries, :region_name, :string
    add_column :countries, :district_name, :string
    us = Country.find_by_country_code("us")
    us.region_name = "state"
    us. district_name = "city"
    us.save!
    uk = Country.find_by_country_code("uk")
    uk.region_name = "county"
    uk. district_name = "town"
    uk.save!
    au = Country.find_by_country_code("au")
    au.region_name = "state"
    au. district_name = "town"
    au.save!
    nz = Country.find_by_country_code("nz")
    nz.region_name = "region"
    nz. district_name = "town"
    nz.save!
  end

  def self.down
    remove_column :countries, :region_name
    remove_column :countries, :district_name
  end
end
