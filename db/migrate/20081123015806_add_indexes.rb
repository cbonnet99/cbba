class AddIndexes < ActiveRecord::Migration
  def self.up
		add_index :roles_users, :user_id
		add_index :roles_users, :role_id
		add_index :users, :subcategory1_id
		add_index :users, :subcategory2_id
		add_index :users, :subcategory3_id
  end

  def self.down
		remove_index :roles_users, :user_id
		remove_index :roles_users, :role_id
		remove_index :users, :subcategory1_id
		remove_index :users, :subcategory2_id
		remove_index :users, :subcategory3_id
  end
end
