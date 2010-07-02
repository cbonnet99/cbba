class AddArticlesPubToSubcategories < ActiveRecord::Migration
  def self.up
    add_column :subcategories, :published_articles_count, :integer, :default => 0
    execute "UPDATE subcategories SET published_articles_count=0" 
    TaskUtils.update_subcategories_counters
  end

  def self.down
    remove_column :subcategories, :published_articles_count
  end
end
