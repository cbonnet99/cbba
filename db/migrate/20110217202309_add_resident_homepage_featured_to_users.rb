class AddResidentHomepageFeaturedToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :homepage_featured_resident, :boolean
    add_column :users, :last_homepage_featured_resident_at, :datetime
    remove_column :users, :feature_rank
  end

  def self.down
    add_column :users, :feature_rank, :integer
    remove_column :users, :last_homepage_featured_resident_at
    remove_column :users, :homepage_featured_resident
  end
end
