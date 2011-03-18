class AddOzCounters < ActiveRecord::Migration
  def self.up
    au = Country.find_by_country_code("au")
    Counter.all.each do |c|
      Counter.create(:country => au, :title => c.title, :class_name => c.class_name, :state => c.state)
    end
    TaskUtils.update_counters
  end

  def self.down
    au = Country.find_by_country_code("au")
    oz_counters = find_all_by_country_id(au.id)
    oz_counters.map(&:delete)
  end
end
