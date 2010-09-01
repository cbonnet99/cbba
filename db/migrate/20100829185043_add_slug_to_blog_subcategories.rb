class AddSlugToBlogSubcategories < ActiveRecord::Migration
  def self.up
    BlogSubcategory.all.each do |s|
      s.save
    end
  end

  def self.down
    remove_column :blog_subcategories, :slug
  end
end
