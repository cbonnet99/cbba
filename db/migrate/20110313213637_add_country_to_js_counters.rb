class AddCountryToJsCounters < ActiveRecord::Migration
  def self.up
    add_column :js_counters, :country_id, :integer
    JsCounter.all.map(&:delete)
  end

  def self.down
    remove_column :js_counters, :country_id
  end
end
