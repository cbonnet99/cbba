class RemoveFeaturedFromArticles < ActiveRecord::Migration
  def self.up
    remove_column :articles, :feature_rank
  end

  def self.down
    add_column :articles, :feature_rank, :integer
  end
end
