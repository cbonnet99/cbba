class AddHomepageFeaturedToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :homepage_featured, :boolean, :default => false 
  end

  def self.down
    remove_column :articles, :homepage_featured
  end
end
