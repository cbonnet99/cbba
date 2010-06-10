class AddNationWideToGiftVouchers < ActiveRecord::Migration
  def self.up
    add_column :gift_vouchers, :nation_wide, :boolean, :default => false 
  end

  def self.down
    remove_column :gift_vouchers, :nation_wide
  end
end
