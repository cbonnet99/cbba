class AddSentByIdToMassEmails < ActiveRecord::Migration
  def self.up
    add_column :mass_emails, :sent_by_id, :integer
  end

  def self.down
    remove_column :mass_emails, :sent_by_id
  end
end
