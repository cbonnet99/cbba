class AddCodeAndDebitToPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :code, :string
    add_column :payments, :debit, :boolean
  end

  def self.down
    remove_column :payments, :debit
    remove_column :payments, :code
  end
end
