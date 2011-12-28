class AddFirstTimeToPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :first_time, :boolean 
  end

  def self.down
    remove_column :payments, :first_time
  end
end
