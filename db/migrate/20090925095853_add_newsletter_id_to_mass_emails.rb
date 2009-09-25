class AddNewsletterIdToMassEmails < ActiveRecord::Migration
  def self.up
    add_column :mass_emails, :newsletter_id, :integer
  end

  def self.down
    remove_column :mass_emails, :newsletter_id
  end
end
