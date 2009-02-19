class AddGstToPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :gst, :integer
  end

  def self.down
    remove_column :payments, :gst
  end
end
