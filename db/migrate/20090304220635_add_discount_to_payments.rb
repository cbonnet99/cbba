class AddDiscountToPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :discount, :integer
  end

  def self.down
    remove_column :payments, :discount
  end
end
