class AddSearchParamsToUserEvents < ActiveRecord::Migration
  def self.up
    add_column :user_events, :what, :string
    add_column :user_events, :where, :string
  end

  def self.down
    remove_column :user_events, :where
    remove_column :user_events, :what
  end
end
