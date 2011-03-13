class AddExampleLocationsToCountries < ActiveRecord::Migration
  def self.up
    add_column :countries, :example_locations, :string
    nz = Country.find_by_country_code("nz")
    nz.update_attribute(:example_locations, "auckland city, canterbury")
    au = Country.find_by_country_code("au")
    au.update_attribute(:example_locations, "sydney, western australia")
  end

  def self.down
    remove_column :countries, :example_locations
  end
end
