class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.string :title
      t.integer :user_id
      t.integer :amount
      t.string :comment
      t.string :invoice_number

      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
