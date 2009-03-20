class AddSentAtToMassEmail < ActiveRecord::Migration
  def self.up
    add_column :mass_emails, :sent_at, :timestamp
  end

  def self.down
    remove_column :mass_emails, :sent_at
  end
end
