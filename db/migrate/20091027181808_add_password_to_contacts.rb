class AddPasswordToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :activated_at, :datetime
    add_column :contacts, :crypted_password, :string, :limit => 40 
    add_column :contacts, :salt, :string, :limit => 40
    add_column :contacts, :remember_token, :string, :limit => 40
    add_column :contacts, :activation_code, :string, :limit => 40
    add_column :contacts, :remember_token_expires_at, :datetime
    add_column :contacts, :state, :string
  end

  def self.down
    remove_column :contacts, :remember_token_expires_at
    remove_column :contacts, :activation_code
    remove_column :contacts, :remember_token
    remove_column :contacts, :salt
    remove_column :contacts, :crypted_password
    remove_column :contacts, :activated_at
    remove_column :contacts, :state
  end
end
