class AddSubcategoryIdToGiftVouchers < ActiveRecord::Migration
  def self.up
    add_column :gift_vouchers, :subcategory_id, :integer
  end

  def self.down
    remove_column :gift_vouchers, :subcategory_id
  end
end
