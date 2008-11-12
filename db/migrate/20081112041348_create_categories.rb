class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name

      t.timestamps
    end
		add_column :users, :category1_id, :integer
		add_column :users, :category2_id, :integer
		add_column :users, :category3_id, :integer
  end

  def self.down
		remove_column :users, :category1_id
		remove_column :users, :category2_id
		remove_column :users, :category3_id
    drop_table :categories
  end
end
