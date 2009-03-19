class CreateMassEmails < ActiveRecord::Migration
  def self.up
    create_table :mass_emails do |t|
      t.string :subject
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :mass_emails
  end
end
