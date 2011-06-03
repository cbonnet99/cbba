class CreateCategoriesCountries < ActiveRecord::Migration
  def self.up
    create_table :categories_countries do |t|
      t.integer :category_id
      t.integer :country_id
      t.integer :count, :default => 0 
      t.timestamps
    end
  end

  def self.down
    drop_table :categories_countries
  end
end
