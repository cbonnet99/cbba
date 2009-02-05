class RemoveOrderTransactions < ActiveRecord::Migration
  def self.up
    drop_table :order_transactions
    create_table :payment_transactions do |t|
      t.integer :payment_id
      t.string :action
      t.integer :amount
      t.boolean :success
      t.string :authorization
      t.string :message
      t.text :params

      t.timestamps
    end
  end

  def self.down
    drop_table :payment_transactions
    create_table :order_transactions do |t|
      t.integer :order_id
      t.string :action
      t.integer :amount
      t.boolean :success
      t.string :authorization
      t.string :message
      t.text :params

      t.timestamps
    end
  end
end
