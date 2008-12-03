class AddPaymentType < ActiveRecord::Migration
  def self.up
    add_column :payments, :payment_type, :string
  end

  def self.down
    remove_column :payments, :payment_type
  end
end
