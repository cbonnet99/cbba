class AddNotifiedAtToPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :notified_at, :datetime
  end

  def self.down
    remove_column :payments, :notified_at
  end
end
