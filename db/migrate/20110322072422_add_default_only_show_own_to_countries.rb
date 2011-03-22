class AddDefaultOnlyShowOwnToCountries < ActiveRecord::Migration
  def self.up
    add_column :countries, :default_only_show_own, :boolean
    nz = Country.find_by_country_code("nz")
    au = Country.find_by_country_code("au")
    nz.update_attribute(:default_only_show_own, true)
    au.update_attribute(:default_only_show_own, false)
  end

  def self.down
    remove_column :countries, :default_only_show_own
  end
end
