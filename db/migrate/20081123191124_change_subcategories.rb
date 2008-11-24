class ChangeSubcategories < ActiveRecord::Migration
  def self.up
		create_table :subcategories_users do |t|
			t.timestamps
			t.integer :subcategory_id
			t.integer :user_id
		end
		add_index :subcategories_users, :subcategory_id
		add_index :subcategories_users, :user_id
		User.all.each do |u|
			unless u.subcategory1_id.nil?
				SubcategoriesUser.create(:user_id => u.id, :subcategory_id => u.subcategory1_id  )
			end
			unless u.subcategory2_id.nil?
				SubcategoriesUser.create(:user_id => u.id, :subcategory_id => u.subcategory2_id  )
			end
			unless u.subcategory3_id.nil?
				SubcategoriesUser.create(:user_id => u.id, :subcategory_id => u.subcategory3_id  )
			end
		end
		remove_column :users, :subcategory1_id
		remove_column :users, :subcategory2_id
		remove_column :users, :subcategory3_id
  end

  def self.down
		add_column :users, :subcategory1_id, :integer
		add_column :users, :subcategory2_id, :integer
		add_column :users, :subcategory3_id, :integer
		drop_table :subcategories_users
  end
end
