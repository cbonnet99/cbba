class AddCharityIdToPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :charity_id, :integer
  end

  def self.down
    remove_column :payments, :charity_id
  end
end
