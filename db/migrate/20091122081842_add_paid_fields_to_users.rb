class AddPaidFieldsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :paid_photo, :boolean
    add_column :users, :paid_highlighted, :boolean
    add_column :users, :paid_special_offers, :integer, :default => 0 
    add_column :users, :paid_gift_vouchers, :integer, :default => 0
    add_column :users, :paid_photo_until, :date
    add_column :users, :paid_highlighted_until, :date
    add_column :users, :paid_gift_vouchers_next_date_check, :date
    add_column :users, :paid_special_offers_next_date_check, :date
  end

  def self.down
    remove_column :users, :paid_photo_until
    remove_column :users, :paid_highlighted_until
    remove_column :users, :paid_gift_vouchers_next_date_check
    remove_column :users, :paid_special_offers_next_date_check
    remove_column :users, :paid_gift_vouchers
    remove_column :users, :paid_special_offers
    remove_column :users, :paid_highlighted
    remove_column :users, :paid_photo
  end
end
