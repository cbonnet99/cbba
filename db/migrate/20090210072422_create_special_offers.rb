class CreateSpecialOffers < ActiveRecord::Migration
  def self.up
    create_table :special_offers do |t|
      t.text :description
      t.text :how_to_book
      t.text :terms
      t.integer :user_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :special_offers
  end
end
