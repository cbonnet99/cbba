class AddFromUserToFriendMessage < ActiveRecord::Migration
  def self.up
    add_column :friend_messages, :from_user_id, :integer
  end

  def self.down
    remove_column :friend_messages, :from_user_id
  end
end
