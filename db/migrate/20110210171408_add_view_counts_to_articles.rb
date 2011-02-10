class AddViewCountsToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :view_counts, :integer, :default => 0
    add_column :articles, :monthly_view_counts, :integer, :default => 0 
    execute("update articles set view_counts=0")
    execute("update articles set monthly_view_counts=0")
  end

  def self.down
    remove_column :articles, :monthly_view_counts
    remove_column :articles, :view_counts
  end
end
