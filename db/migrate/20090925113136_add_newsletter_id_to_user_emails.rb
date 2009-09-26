class AddNewsletterIdToUserEmails < ActiveRecord::Migration
  def self.up
    add_column :user_emails, :newsletter_id, :integer
  end

  def self.down
    remove_column :user_emails, :newsletter_id
  end
end
