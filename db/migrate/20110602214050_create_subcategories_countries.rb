class CreateSubcategoriesCountries < ActiveRecord::Migration
  def self.up
    create_table :subcategories_countries do |t|
      t.integer :subcategory_id
      t.integer :country_id
      t.integer :count, :default => 0 

      t.timestamps
    end
  end

  def self.down
    drop_table :subcategories_countries
  end
end
