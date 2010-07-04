class CreateStoredTokens < ActiveRecord::Migration
  def self.up
    create_table :stored_tokens do |t|
      t.integer :user_id
      t.string :billing_id
      t.date :expires_on

      t.timestamps
    end
  end

  def self.down
    drop_table :stored_tokens
  end
end
