class AddTokenToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :unsubscribe_token, :string
  end

  def self.down
    remove_column :contacts, :unsubscribe_token
  end
end
