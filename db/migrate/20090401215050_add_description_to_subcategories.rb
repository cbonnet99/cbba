class AddDescriptionToSubcategories < ActiveRecord::Migration
  def self.up
    add_column :subcategories, :description, :text
  end

  def self.down
    remove_column :subcategories, :description
  end
end
