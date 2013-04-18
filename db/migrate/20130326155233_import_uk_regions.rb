require File.dirname(__FILE__) + '/../../lib/helpers'
require 'csv'

class ImportUkRegions < ActiveRecord::Migration
  def self.up
    uk = Country.find_by_country_code("uk")
    CSV.foreach("#{RAILS_ROOT}/csv/uk_places.csv") do |row|
      region_name = row[0]
      district_name = row[1]
      region = Region.find_by_name(region_name)
      if region.nil?
        region = Region.create(:country_id => uk.id, :name => region_name)  
        puts "Created region: #{region_name}"
      end
      District.create(:country_id => uk.id, :region => region, :name => district_name)
      puts "Created district: #{district_name} in region #{region.name}"
    end
    TaskUtils.generate_autocomplete_regions
  end

  def self.down
    uk = Country.find_by_country_code("uk")
    District.find_all_by_country_id(uk.id).map(&:delete)
    Region.find_all_by_country_id(uk.id).map(&:delete)
  end
end
