class AddLastFeaturedAtToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :last_homepage_featured_at, :datetime
  end

  def self.down
    remove_column :users, :last_homepage_featured_at
  end
end
