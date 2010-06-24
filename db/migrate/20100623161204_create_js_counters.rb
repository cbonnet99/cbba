class CreateJsCounters < ActiveRecord::Migration
  def self.up
    create_table :js_counters do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :js_counters
  end
end
