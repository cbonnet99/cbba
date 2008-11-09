class AddBooleansToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :receive_newsletter, :boolean, :default => true 
    add_column :users, :professional, :boolean, :default => false
  end

  def self.down
    remove_column :users, :receive_newsletter
    remove_column :users, :professional
  end
end
