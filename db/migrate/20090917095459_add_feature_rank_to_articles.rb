class AddFeatureRankToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :feature_rank, :integer
  end

  def self.down
    remove_column :articles, :feature_rank
  end
end
