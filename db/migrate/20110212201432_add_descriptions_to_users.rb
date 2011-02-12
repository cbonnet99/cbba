class AddDescriptionsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :expertise_description, :string
    add_column :users, :resident_expertise_description, :string
  end

  def self.down
    remove_column :users, :resident_expertise_description
    remove_column :users, :expertise_description
  end
end
