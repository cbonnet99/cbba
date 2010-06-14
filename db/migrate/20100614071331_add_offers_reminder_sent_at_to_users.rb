class AddOffersReminderSentAtToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :offers_reminder_sent_at, :datetime
  end

  def self.down
    remove_column :users, :offers_reminder_sent_at
  end
end
