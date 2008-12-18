class AddExpertisePositionToSubcategoriesUsers < ActiveRecord::Migration
  def self.up
    add_column :subcategories_users, :expertise_position, :integer
  end

  def self.down
    remove_column :subcategories_users, :expertise_position
  end
end
