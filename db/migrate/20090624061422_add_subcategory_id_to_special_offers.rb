class AddSubcategoryIdToSpecialOffers < ActiveRecord::Migration
  def self.up
    add_column :special_offers, :subcategory_id, :integer
  end

  def self.down
    remove_column :special_offers, :subcategory_id
  end
end
