class RemoveOrders < ActiveRecord::Migration
  def self.up
    drop_table :orders
    add_column :payments, :ip_address, :string
    add_column :payments, :first_name, :string
    add_column :payments, :last_name, :string
    add_column :payments, :address1, :text
    add_column :payments, :city, :string
    add_column :payments, :card_type, :string
    add_column :payments, :card_expires_on, :string
  end

  def self.down
    remove_column :payments, :ip_address, :string
    remove_column :payments, :first_name, :string
    remove_column :payments, :last_name, :string
    remove_column :payments, :address1, :text
    remove_column :payments, :city, :string
    remove_column :payments, :card_type, :string
    remove_column :payments, :card_expires_on, :string
    create_table :orders do |t|
      t.integer :payment_id
      t.string :ip_address
      t.string :first_name
      t.string :last_name
      t.text :address1
      t.string :city
      t.string :card_type
      t.date :card_expires_on
      t.timestamps
    end
  end
end
