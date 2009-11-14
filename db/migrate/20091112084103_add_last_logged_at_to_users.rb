class AddLastLoggedAtToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :last_logged_at, :timestamp
  end

  def self.down
    remove_column :users, :last_logged_at
  end
end
