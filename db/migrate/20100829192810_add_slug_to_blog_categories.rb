class AddSlugToBlogCategories < ActiveRecord::Migration
  def self.up
    add_column :blog_categories, :slug, :string
    BlogCategory.all.each do |c|
      c.save
    end
  end

  def self.down
    remove_column :blog_categories, :slug
  end
end
