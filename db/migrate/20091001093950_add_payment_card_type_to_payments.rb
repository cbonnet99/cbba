class AddPaymentCardTypeToPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :payment_card_type, :string
  end

  def self.down
    remove_column :payments, :payment_card_type
  end
end
