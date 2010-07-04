class AddNamesToStoredTokens < ActiveRecord::Migration
  def self.up
    add_column :stored_tokens, :first_name, :string
    add_column :stored_tokens, :last_name, :string
  end

  def self.down
    remove_column :stored_tokens, :last_name
    remove_column :stored_tokens, :first_name
  end
end
