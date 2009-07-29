class AddStuffToUserEmails < ActiveRecord::Migration
  def self.up
    add_column :user_emails, :sent_at, :datetime
    add_column :user_emails, :subject, :string
    add_column :user_emails, :body, :text
    add_column :user_emails, :mass_email_id, :integer
    execute("UPDATE user_emails SET sent_at = now()")
  end

  def self.down
    remove_column :user_emails, :body
    remove_column :user_emails, :subject
    remove_column :user_emails, :sent_at
    remove_column :user_emails, :mass_email_id
  end
end
