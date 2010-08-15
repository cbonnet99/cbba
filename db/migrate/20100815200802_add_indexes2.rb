class AddIndexes2 < ActiveRecord::Migration
  def self.up
    add_index :categories, [:position, :name]
    add_index :users, :state
    add_index :articles, :state
    add_index :how_tos, :state
    add_index :districts, :id
    add_index :subcategories_users, :expertise_position
    add_index :tabs, :position
    add_index :regions, :id
  end

  def self.down
    remove_index :categories, [:position, :name]
    remove_index :users, :state
    remove_index :articles, :state
    remove_index :how_tos, :state
    remove_index :districts, :id
    remove_index :subcategories_users, :expertise_position
    remove_index :tabs, :position
    remove_index :regions, :id
  end
end
