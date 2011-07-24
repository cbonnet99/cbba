class AddNewsDigestToUserEmails < ActiveRecord::Migration
  def self.up
    add_column :user_emails, :news_digest_id, :integer
  end

  def self.down
    remove_column :user_emails, :news_digest_id
  end
end
