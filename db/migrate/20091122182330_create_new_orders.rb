class CreateNewOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.integer :user_id
      t.string :order_number
      t.boolean :photo
      t.boolean :highlighted
      t.integer :special_offers
      t.integer :gift_vouchers
      t.boolean :whole_package
      t.string :state
      t.timestamps
    end
  end
  
  def self.down
    drop_table :orders
  end
end
