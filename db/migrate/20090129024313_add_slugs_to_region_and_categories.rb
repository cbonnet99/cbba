class AddSlugsToRegionAndCategories < ActiveRecord::Migration
  def self.up
    add_column :regions, :slug, :string
    add_column :categories, :slug, :string
    add_column :subcategories, :slug, :string
  end

  def self.down
    remove_column :regions, :slug, :string
    remove_column :categories, :slug, :string
    remove_column :subcategories, :slug, :string
  end
end
