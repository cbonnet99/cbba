class SetPaidGvAndSoTo0 < ActiveRecord::Migration
  def self.up
    execute "update users set paid_special_offers=0 where paid_special_offers is null"
    execute "update users set paid_gift_vouchers=0 where paid_gift_vouchers is null"
  end

  def self.down
  end
end
