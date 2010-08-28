class AddAboutToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :about, :string, :limit => 600
    change_column :users, :about, :string, :limit => 600
  end

  def self.down
    remove_column :articles, :about
  end
end
