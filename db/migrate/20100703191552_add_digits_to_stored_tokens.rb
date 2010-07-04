class AddDigitsToStoredTokens < ActiveRecord::Migration
  def self.up
    add_column :stored_tokens, :last4digits, :string, :size => 4 
  end

  def self.down
    remove_column :stored_tokens, :last4digits
  end
end
