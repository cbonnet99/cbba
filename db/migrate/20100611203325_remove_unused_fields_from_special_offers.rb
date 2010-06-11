class RemoveUnusedFieldsFromSpecialOffers < ActiveRecord::Migration
  def self.up
    remove_column :special_offers, :terms
    remove_column :special_offers, :how_to_book
  end

  def self.down
    add_column :special_offers, :terms, :text
    add_column :special_offers, :how_to_book, :text
  end
end
