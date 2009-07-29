class AddContactToUserEmails < ActiveRecord::Migration
  def self.up
    add_column :user_emails, :contact_id, :integer
  end

  def self.down
    remove_column :user_emails, :contact_id
  end
end
