class ReplaceUserWithAuthor < ActiveRecord::Migration
  def self.up
    add_column :special_offers, :author_id, :integer
    SpecialOffer.all.each do |so|
      so.update_attribute(:author_id, so.user_id)
    end
    remove_column :special_offers, :user_id
  end

  def self.down
    add_column :special_offers, :user_id, :integer
    SpecialOffer.all.each do |so|
      so.update_attribute(:user_id, so.author_id)
    end
    remove_column :special_offers, :author_id
  end
end
