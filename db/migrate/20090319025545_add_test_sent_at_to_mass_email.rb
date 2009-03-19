class AddTestSentAtToMassEmail < ActiveRecord::Migration
  def self.up
    add_column :mass_emails, :test_sent_at, :timestamp
    add_column :mass_emails, :test_sent_to_id, :integer
    add_column :mass_emails, :recipients, :string
  end

  def self.down
    remove_column :mass_emails, :recipients
    remove_column :mass_emails, :test_sent_to_id
    remove_column :mass_emails, :test_sent_at
  end
end
