class AddBrowserToUserEvents < ActiveRecord::Migration
  def self.up
    add_column :user_events, :browser, :string
  end

  def self.down
    remove_column :user_events, :browser
  end
end
