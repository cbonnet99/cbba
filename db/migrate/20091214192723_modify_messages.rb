class ModifyMessages < ActiveRecord::Migration
  def self.up
    rename_column :messages, :preferred_contact, :email
    add_column :messages, :phone, :string
  end

  def self.down
    remove_column :messages, :phone
    rename_column :messages, :email, :preferred_contact
  end
end
