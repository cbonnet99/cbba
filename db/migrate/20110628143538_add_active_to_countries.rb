class AddActiveToCountries < ActiveRecord::Migration
  def self.up
    add_column :countries, :active, :boolean, :default => false 
    
    Country.all.each {|c| c.update_attribute(:active, true)}
  end

  def self.down
    remove_column :countries, :active
  end
end
