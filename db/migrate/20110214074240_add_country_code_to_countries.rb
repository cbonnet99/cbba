class AddCountryCodeToCountries < ActiveRecord::Migration
  def self.up
    add_column :countries, :country_code, :string, :size => 2
    add_column :countries, :top_domain, :string, :size => 10
    nz = Country.find_by_currency("NZD")
    nz.update_attribute(:country_code, "nz") 
    nz.update_attribute(:top_domain, "co.nz") 
    au = Country.find_by_currency("AUD")
    au.update_attribute(:country_code, "au") 
    au.update_attribute(:top_domain, "com.au") 
  end

  def self.down
    remove_column :countries, :country_code
    remove_column :countries, :top_domain
  end
end
