class AddTokenToPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :stored_token_id, :integer
  end

  def self.down
    remove_column :payments, :stored_token_id
  end
end
