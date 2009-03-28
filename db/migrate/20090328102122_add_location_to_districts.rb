class AddLocationToDistricts < ActiveRecord::Migration
  def self.up
    add_column :districts, :latitude, :string
    add_column :districts, :longitude, :string
  end

  def self.down
    remove_column :districts, :longitude
    remove_column :districts, :latitude
  end
end
