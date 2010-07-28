class AddSubcatToTabs < ActiveRecord::Migration
  def self.up
    add_column :tabs, :subcategory_id, :integer
  end

  def self.down
    remove_column :tabs, :subcategory_id
  end
end
