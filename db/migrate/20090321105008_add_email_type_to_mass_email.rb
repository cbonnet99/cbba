class AddEmailTypeToMassEmail < ActiveRecord::Migration
  def self.up
    add_column :mass_emails, :email_type, :string
  end

  def self.down
    remove_column :mass_emails, :email_type
  end
end
