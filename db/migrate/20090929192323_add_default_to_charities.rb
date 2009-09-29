class AddDefaultToCharities < ActiveRecord::Migration
  def self.up
    add_column :charities, :default_choice, :boolean
  end

  def self.down
    remove_column :charities, :default_choice
  end
end
