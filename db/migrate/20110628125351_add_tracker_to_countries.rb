class AddTrackerToCountries < ActiveRecord::Migration
  def self.up
    add_column :countries, :analytics_tracker, :string
  end

  def self.down
    remove_column :countries, :analytics_tracker
  end
end
