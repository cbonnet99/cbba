class AddTokenToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :unsubscribe_token, :string
  end

  def self.down
    remove_column :users, :unsubscribe_token
  end
end
