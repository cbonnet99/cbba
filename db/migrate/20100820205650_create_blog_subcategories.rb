class CreateBlogSubcategories < ActiveRecord::Migration
  def self.up
    create_table :blog_subcategories do |t|
      t.integer :blog_category_id
      t.string :name
      t.string :slug
      t.timestamps
    end
    TaskUtils.import_blog_categories
  end

  def self.down
    drop_table :blog_subcategories
  end
end
