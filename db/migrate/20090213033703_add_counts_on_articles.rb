class AddCountsOnArticles < ActiveRecord::Migration
  def self.up
    add_column :users, :articles_count, :integer, :default => 0
    add_column :users, :how_tos_count, :integer, :default => 0
    add_column :users, :special_offers_count, :integer, :default => 0
    add_column :users, :published_articles_count, :integer, :default => 0
    add_column :users, :published_how_tos_count, :integer, :default => 0
    add_column :users, :published_special_offers_count, :integer, :default => 0
    User.all.each do |u|
      u.update_attribute(:articles_count, u.articles.count)
      u.update_attribute(:how_tos_count, u.how_tos.count)
      u.update_attribute(:special_offers_count, u.special_offers.count)
      u.update_attribute(:published_articles_count, u.articles.published.count)
      u.update_attribute(:published_how_tos_count, u.how_tos.published.count)
      u.update_attribute(:published_special_offers_count, u.special_offers.published.count)
    end
  end

  def self.down
    remove_column :users, :articles_count
    remove_column :users, :how_tos_count
    remove_column :users, :special_offers_count
    remove_column :users, :published_articles_count
    remove_column :users, :published_how_tos_count
    remove_column :users, :published_special_offers_count
  end
end
