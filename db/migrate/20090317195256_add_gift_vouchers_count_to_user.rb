class AddGiftVouchersCountToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :gift_vouchers_count, :integer, :default => 0
  end

  def self.down
    remove_column :users, :gift_vouchers_count
  end
end
