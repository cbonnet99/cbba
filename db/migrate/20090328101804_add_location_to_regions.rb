class AddLocationToRegions < ActiveRecord::Migration
  def self.up
    add_column :regions, :latitude, :string
    add_column :regions, :longitude, :string
  end

  def self.down
    remove_column :regions, :longitude
    remove_column :regions, :latitude
  end
end
