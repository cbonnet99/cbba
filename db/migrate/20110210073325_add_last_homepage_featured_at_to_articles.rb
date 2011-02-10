class AddLastHomepageFeaturedAtToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :last_homepage_featured_at, :datetime
  end

  def self.down
    remove_column :articles, :last_homepage_featured_at
  end
end
