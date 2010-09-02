class CreateBlogCategories < ActiveRecord::Migration
  def self.up
    create_table :blog_categories do |t|
      t.string :name
      t.string :slug
      t.timestamps
    end
  end

  def self.down
    drop_table :blog_categories
  end
end
