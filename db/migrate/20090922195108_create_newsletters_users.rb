class CreateNewslettersUsers < ActiveRecord::Migration
  def self.up
    create_table :newsletters_users do |t|
      t.integer :user_id
      t.integer :newsletter_id

      t.timestamps
    end
  end

  def self.down
    drop_table :newsletters_users
  end
end
