class RemoveCountsFromSubcats < ActiveRecord::Migration
  def self.up
    remove_column :subcategories, :published_gift_vouchers_count
    remove_column :subcategories, :published_special_offers_count
    remove_column :subcategories, :published_articles_count    
  end

  def self.down
    add_column :subcategories, :published_gift_vouchers_count, :integer
    add_column :subcategories, :published_special_offers_count, :integer
    add_column :subcategories, :published_articles_count, :integer
  end
end
