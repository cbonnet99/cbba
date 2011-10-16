class AddDefaultToCountries < ActiveRecord::Migration
  def self.up
    add_column :countries, :default_country, :boolean
  end

  def self.down
    remove_column :countries, :default_country
  end
end
