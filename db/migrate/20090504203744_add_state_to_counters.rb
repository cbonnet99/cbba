class AddStateToCounters < ActiveRecord::Migration
  def self.up
    add_column :counters, :state, :string, :default => "draft" 
  end

  def self.down
    remove_column :counters, :state
  end
end
