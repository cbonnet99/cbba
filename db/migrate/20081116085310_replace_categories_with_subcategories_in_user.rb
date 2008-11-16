class ReplaceCategoriesWithSubcategoriesInUser < ActiveRecord::Migration
  def self.up
		remove_column :users, :category1_id
		remove_column :users, :category2_id
		remove_column :users, :category3_id
		add_column :users, :subcategory1_id, :integer
		add_column :users, :subcategory2_id, :integer
		add_column :users, :subcategory3_id, :integer
  end

  def self.down
		add_column :users, :category1_id, :integer
		add_column :users, :category2_id, :integer
		add_column :users, :category3_id, :integer
		remove_column :users, :subcategory1_id
		remove_column :users, :subcategory2_id
		remove_column :users, :subcategory3_id
  end
end
