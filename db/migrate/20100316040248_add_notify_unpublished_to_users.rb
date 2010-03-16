class AddNotifyUnpublishedToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :notify_unpublished, :boolean
    execute "UPDATE users SET notify_unpublished=true"
  end

  def self.down
    remove_column :users, :notify_unpublished
  end
end
