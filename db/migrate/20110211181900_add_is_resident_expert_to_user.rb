class AddIsResidentExpertToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :is_resident_expert, :boolean
  end

  def self.down
    remove_column :users, :is_resident_expert
  end
end
