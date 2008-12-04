class CreateCategoriesUsers < ActiveRecord::Migration
  def self.up
		create_table :categories_users do |t|
			t.timestamps
			t.integer :category_id
			t.integer :user_id
      t.integer :position
		end
		add_index :categories_users, :category_id
		add_index :categories_users, :user_id
  end

  def self.down
    drop_table :categories_users
  end
end
