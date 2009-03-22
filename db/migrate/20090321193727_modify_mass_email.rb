class ModifyMassEmail < ActiveRecord::Migration
  def self.up
    remove_column :mass_emails, :recipients
    add_column :mass_emails, :recipients_resident_experts, :boolean, :default => false
    add_column :mass_emails, :recipients_full_members, :boolean, :default => false
    add_column :mass_emails, :recipients_free_users, :boolean, :default => false
    add_column :mass_emails, :recipients_general_public, :boolean, :default => false
  end

  def self.down
    remove_column :mass_emails, :recipients_resident_experts
    remove_column :mass_emails, :recipients_full_members
    remove_column :mass_emails, :recipients_free_users
    remove_column :mass_emails, :recipients_general_public
    add_column :mass_emails, :recipients, :string
  end
end
