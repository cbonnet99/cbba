class AddSlugs < ActiveRecord::Migration
  def self.up
    add_column :users, :slug, :string
    add_column :tabs, :slug, :string
  end

  def self.down
    remove_column :users, :slug
    remove_column :tabs, :slug
  end
end
