class CreateUserEmails < ActiveRecord::Migration
  def self.up
    create_table :user_emails do |t|
      t.integer :user_id
      t.string :email_type

      t.timestamps
    end
  end

  def self.down
    drop_table :user_emails
  end
end
