class AddCountMethodToCounters < ActiveRecord::Migration
  def self.up
    add_column :counters, :count_method, :string
  end

  def self.down
    remove_column :counters, :count_method
  end
end
