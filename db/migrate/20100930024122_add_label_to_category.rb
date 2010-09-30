class AddLabelToCategory < ActiveRecord::Migration
  def self.up
    add_column :categories, :label, :string
  end

  def self.down
    remove_column :categories, :label
  end
end
