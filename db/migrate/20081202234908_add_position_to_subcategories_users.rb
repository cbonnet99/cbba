class AddPositionToSubcategoriesUsers < ActiveRecord::Migration
  def self.up
    add_column :subcategories_users, :position, :integer
  end

  def self.down
    remove_column :subcategories_users, :position
  end
end
