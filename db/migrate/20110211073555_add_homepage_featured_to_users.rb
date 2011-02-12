class AddHomepageFeaturedToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :homepage_featured, :boolean, :default => false 
  end

  def self.down
    remove_column :users, :homepage_featured
  end
end
