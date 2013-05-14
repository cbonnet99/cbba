class AddUkAndUsCounters < ActiveRecord::Migration
  def self.up
    uk = Country.find_by_country_code("uk")
    us = Country.find_by_country_code("us")
    au = Country.find_by_country_code("au")
    
    au_counters = Counter.find_all_by_country_id(au.id)
    au_counters.each do |c|
      Counter.create(:country => uk, :title => c.title, :class_name => c.class_name, :state => c.state, :count_method => c.count_method)
      Counter.create(:country => us, :title => c.title, :class_name => c.class_name, :state => c.state, :count_method => c.count_method)
    end
    TaskUtils.update_counters
  end

  def self.down
    uk = Country.find_by_country_code("uk")
    us = Country.find_by_country_code("us")
    uk_counters = Counter.find_all_by_country_id(uk.id)
    uk_counters.map(&:delete)
    us_counters = Counter.find_all_by_country_id(us.id)
    us_counters.map(&:delete)
  end
end
