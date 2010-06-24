class CreateFriendMessages < ActiveRecord::Migration
  def self.up
    create_table :friend_messages do |t|
      t.string :from_email
      t.string :from_name
      t.string :to_email
      t.string :to_name
      t.string :subject
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :friend_messages
  end
end
