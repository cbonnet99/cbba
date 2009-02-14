class AddGeocodesToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :latitude, :string
    add_column :users, :longitude, :string
  end

  def self.down
    remove_column :users, :latitude
    remove_column :users, :longitude
  end
end
