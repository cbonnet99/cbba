class CreateArticlesCategories < ActiveRecord::Migration
  def self.up
		create_table :articles_categories do |t|
			t.timestamps
			t.integer :category_id
			t.integer :article_id
      t.integer :position
		end
		add_index :articles_categories, :category_id
		add_index :articles_categories, :article_id
  end

  def self.down
    drop_table :articles_categories
  end
end
