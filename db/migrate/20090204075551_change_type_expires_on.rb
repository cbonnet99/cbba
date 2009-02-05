class ChangeTypeExpiresOn < ActiveRecord::Migration
  def self.up
    remove_column :payments, :card_expires_on
    add_column :payments, :card_expires_on, :date
  end

  def self.down
    remove_column :payments, :card_expires_on
    add_column :payments, :card_expires_on, :string
  end
end
