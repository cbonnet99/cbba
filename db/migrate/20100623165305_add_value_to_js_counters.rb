class AddValueToJsCounters < ActiveRecord::Migration
  def self.up
    add_column :js_counters, :value, :integer
  end

  def self.down
    remove_column :js_counters, :value
  end
end
