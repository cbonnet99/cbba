class CreateCountries < ActiveRecord::Migration
  def self.up
    create_table :countries do |t|
      t.string :name
      t.string :currency
      t.timestamps
    end
    nz = Country.create(:name => "New Zealand", :currency => "NZD")
    au = Country.create(:name => "Australia", :currency => "AUD")
    add_column :users, :country_id, :integer
    add_column :contacts, :country_id, :integer
    add_column :articles, :country_id, :integer
    add_column :counters, :country_id, :integer
    add_column :districts, :country_id, :integer
    add_column :gift_vouchers, :country_id, :integer
    add_column :how_tos, :country_id, :integer
    add_column :regions, :country_id, :integer
    add_column :special_offers, :country_id, :integer
    execute("update users set country_id=#{nz.id}")
    execute("update contacts set country_id=#{nz.id}")
    execute("update articles set country_id=#{nz.id}")
    execute("update counters set country_id=#{nz.id}")
    execute("update districts set country_id=#{nz.id}")
    execute("update gift_vouchers set country_id=#{nz.id}")
    execute("update how_tos set country_id=#{nz.id}")
    execute("update regions set country_id=#{nz.id}")
    execute("update special_offers set country_id=#{nz.id}")
  end

  def self.down
    drop_table :countries
    remove_column :users, :country_id
    remove_column :contacts, :country_id
    remove_column :articles, :country_id
    remove_column :counters, :country_id
    remove_column :districts, :country_id
    remove_column :gift_vouchers, :country_id
    remove_column :how_tos, :country_id
    remove_column :regions, :country_id
    remove_column :special_offers, :country_id
  end
end
