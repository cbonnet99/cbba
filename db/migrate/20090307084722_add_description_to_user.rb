class AddDescriptionToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :description, :string, :size => 250
  end

  def self.down
    remove_column :users, :description
  end
end
