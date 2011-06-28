class AddAdjectiveToCountries < ActiveRecord::Migration
  def self.up
    add_column :countries, :adjective, :string
  end

  def self.down
    remove_column :countries, :adjective
  end
end
