class ChangeSubcategoriesForArticles < ActiveRecord::Migration
  def self.up
		create_table :articles_subcategories do |t|
			t.timestamps
			t.integer :subcategory_id
			t.integer :article_id
		end
		add_index :articles_subcategories, :subcategory_id
		add_index :articles_subcategories, :article_id
		Article.all.each do |a|
			unless a.subcategory1_id.nil?
				ArticlesSubcategory.create(:article_id => a.id, :subcategory_id => a.subcategory1_id  )
			end
			unless a.subcategory2_id.nil?
				ArticlesSubcategories.create(:article_id => a.id, :subcategory_id => a.subcategory2_id  )
			end
			unless a.subcategory3_id.nil?
				ArticlesSubcategories.create(:article_id => a.id, :subcategory_id => a.subcategory3_id  )
			end
		end
		remove_column :articles, :subcategory1_id
		remove_column :articles, :subcategory2_id
		remove_column :articles, :subcategory3_id
  end

  def self.down
		add_column :articles, :subcategory1_id, :integer
		add_column :articles, :subcategory2_id, :integer
		add_column :articles, :subcategory3_id, :integer
		drop_table :articles_subcategories
  end
end
