class CreateGiftVouchersNewsletters < ActiveRecord::Migration
  def self.up
    create_table :gift_vouchers_newsletters do |t|
      t.integer :gift_voucher_id
      t.integer :newsletter_id

      t.timestamps
    end
  end

  def self.down
    drop_table :gift_vouchers_newsletters
  end
end
