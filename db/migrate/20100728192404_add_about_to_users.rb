class AddAboutToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :about, :string, :size => 600 
  end

  def self.down
    remove_column :users, :about
  end
end
