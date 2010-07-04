class AddCardExpiresOnToStoredTokens < ActiveRecord::Migration
  def self.up
    add_column :stored_tokens, :card_expires_on, :date
    remove_column :stored_tokens, :expires_on
  end

  def self.down
    add_column :stored_tokens, :expires_on, :date
    remove_column :stored_tokens, :card_expires_on
  end
end
