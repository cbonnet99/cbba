class AddCountryToMassEmails < ActiveRecord::Migration
  def self.up
    nz = Country.find_by_country_code("nz")
    add_column :mass_emails, :country_id, :integer
    execute("update mass_emails set country_id=#{nz.id}")
  end

  def self.down
    remove_column :mass_emails, :country_id
  end
end
