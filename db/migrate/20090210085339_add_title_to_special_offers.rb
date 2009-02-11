class AddTitleToSpecialOffers < ActiveRecord::Migration
  def self.up
    add_column :special_offers, :title, :string
  end

  def self.down
    remove_column :special_offers, :title
  end
end
