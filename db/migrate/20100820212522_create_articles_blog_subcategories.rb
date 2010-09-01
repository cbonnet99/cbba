class CreateArticlesBlogSubcategories < ActiveRecord::Migration
  def self.up
    create_table :articles_blog_subcategories do |t|
      t.integer :article_id
      t.integer :blog_subcategory_id
      t.string :slug
      t.timestamps
    end
  end

  def self.down
    drop_table :articles_blog_subcategories
  end
end
