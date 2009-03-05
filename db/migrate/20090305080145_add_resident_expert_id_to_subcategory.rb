class AddResidentExpertIdToSubcategory < ActiveRecord::Migration
  def self.up
    add_column :subcategories, :resident_expert_id, :integer
  end

  def self.down
    remove_column :subcategories, :resident_expert_id
  end
end
