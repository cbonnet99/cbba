class AddInhabitantsToCountries < ActiveRecord::Migration
  def self.up
    add_column :countries, :inhabitants, :string
    nz = Country.find_by_country_code("nz")
    nz.update_attribute(:inhabitants, "New Zealanders")
    au = Country.find_by_country_code("au")
    au.update_attribute(:inhabitants, "Australians")
  end

  def self.down
    remove_column :countries, :inhabitants
  end
end
