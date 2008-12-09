class AddFieldsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :member_since, :timestamp
    add_column :users, :member_until, :timestamp
  end

  def self.down
    remove_column :users, :member_since
    remove_column :users, :member_until
  end
end
