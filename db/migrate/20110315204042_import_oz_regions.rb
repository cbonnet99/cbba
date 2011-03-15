require 'csv'

class ImportOzRegions < ActiveRecord::Migration
  def self.up
    au = Country.find_by_country_code("au")
    CSV.foreach("#{RAILS_ROOT}/csv/australian_places.csv") do |row|
      region_name = row[0]
      district_name = row[1]
      region = Region.find_by_name(region_name)
      if region.nil?
        region = Region.create(:country => au, :name => region_name)  
        puts "Created region: #{region_name}"
      end
      District.create(:country => au, :region => region, :name => district_name)
      puts "Created district: #{district_name} in region #{region.name}"
    end
    TaskUtils.generate_autocomplete_regions
  end

  def self.down
    au = Country.find_by_country_code("au")
    District.find_all_by_country_id(au.id).map(&:delete)
    Region.find_all_by_country_id(au.id).map(&:delete)
  end
end
