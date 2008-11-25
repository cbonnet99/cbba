class AddCounters < ActiveRecord::Migration
  def self.up
		add_column :categories, :users_counter, :integer, :default => 0
		add_column :subcategories, :users_counter, :integer, :default => 0
  end

  def self.down
		remove_column :categories, :users_counter
		remove_column :subcategories, :users_counter
  end
end
