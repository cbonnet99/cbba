class AddNationWideToSpecialOffers < ActiveRecord::Migration
  def self.up
    add_column :special_offers, :nation_wide, :boolean, :default => false 
  end

  def self.down
    remove_column :special_offers, :nation_wide
  end
end
