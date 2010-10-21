class AddBodyToNewsletters < ActiveRecord::Migration
  def self.up
    add_column :newsletters, :body, :text
  end

  def self.down
    remove_column :newsletters, :body
  end
end
