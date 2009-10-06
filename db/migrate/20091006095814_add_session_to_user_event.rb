class AddSessionToUserEvent < ActiveRecord::Migration
  def self.up
    add_column :user_events, :session, :string
  end

  def self.down
    remove_column :user_events, :session
  end
end
