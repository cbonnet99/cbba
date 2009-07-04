class AddStuffToMassEmails < ActiveRecord::Migration
  def self.up
    add_column :mass_emails, :creator_id, :integer
    add_column :mass_emails, :sent_to, :text
  end

  def self.down
    remove_column :mass_emails, :sent_to
    remove_column :mass_emails, :creator_id
  end
end
