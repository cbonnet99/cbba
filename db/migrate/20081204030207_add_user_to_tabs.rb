class AddUserToTabs < ActiveRecord::Migration
  def self.up
    add_column :tabs, :user_id, :integer
    add_index :tabs, :user_id
  end

  def self.down
    remove_column :tabs, :user_id
  end
end
