class ChangeRecipientsForMassEmails < ActiveRecord::Migration
  def self.up
    remove_column :mass_emails, :recipients_resident_experts
    remove_column :mass_emails, :recipients_full_members
    remove_column :mass_emails, :recipients_free_users
    remove_column :mass_emails, :recipients_general_public
    add_column :mass_emails, :recipients, :string
  end

  def self.down
    add_column :mass_emails, :recipients_resident_experts, :boolean
    add_column :mass_emails, :recipients_full_members, :boolean
    add_column :mass_emails, :recipients_free_users, :boolean
    add_column :mass_emails, :recipients_general_public, :boolean
    remove_column :mass_emails, :recipients
  end
end
