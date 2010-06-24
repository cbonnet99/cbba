class AddSentAtToFriendMessages < ActiveRecord::Migration
  def self.up
    add_column :friend_messages, :sent_at, :datetime
  end

  def self.down
    remove_column :friend_messages, :sent_at
  end
end
