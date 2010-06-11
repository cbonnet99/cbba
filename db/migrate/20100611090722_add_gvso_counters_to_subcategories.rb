class AddGvsoCountersToSubcategories < ActiveRecord::Migration
  def self.up
    add_column :subcategories, :published_gift_vouchers_count, :integer, :default => 0 
    add_column :subcategories, :published_special_offers_count, :integer, :default => 0
    execute "update subcategories set published_gift_vouchers_count=0"
    execute "update subcategories set published_special_offers_count=0"
    TaskUtils.count_offers
  end

  def self.down
    remove_column :subcategories, :published_special_offers_count
    remove_column :subcategories, :published_gift_vouchers_count
  end
end
