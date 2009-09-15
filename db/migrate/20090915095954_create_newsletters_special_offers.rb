class CreateNewslettersSpecialOffers < ActiveRecord::Migration
  def self.up
    create_table :newsletters_special_offers do |t|
      t.integer :newsletter_id
      t.integer :special_offer_id

      t.timestamps
    end
  end

  def self.down
    drop_table :newsletters_special_offers
  end
end
