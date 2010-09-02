class CreateArticlesBlogCategories < ActiveRecord::Migration
  def self.up
    create_table :articles_blog_categories do |t|
      t.integer :article_id
      t.integer :blog_category_id
      t.timestamps
    end
  end

  def self.down
    drop_table :articles_blog_categories
  end
end
