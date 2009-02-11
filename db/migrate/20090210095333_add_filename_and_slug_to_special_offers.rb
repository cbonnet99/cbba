class AddFilenameAndSlugToSpecialOffers < ActiveRecord::Migration
  def self.up
    add_column :special_offers, :slug, :string
    add_column :special_offers, :filename, :string
  end

  def self.down
    remove_column :special_offers, :slug
    remove_column :special_offers, :filename
  end
end
