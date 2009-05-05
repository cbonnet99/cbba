class AddClassNameToCounters < ActiveRecord::Migration
  def self.up
    add_column :counters, :class_name, :string
  end

  def self.down
    remove_column :counters, :class_name
  end
end
