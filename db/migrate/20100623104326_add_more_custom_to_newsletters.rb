class AddMoreCustomToNewsletters < ActiveRecord::Migration
  def self.up
    add_column :newsletters, :custom3_title, :string
    add_column :newsletters, :custom3_body, :text
    add_column :newsletters, :custom4_title, :string
    add_column :newsletters, :custom4_body, :text
  end

  def self.down
    remove_column :newsletters, :custom3_body
    remove_column :newsletters, :custom3_title
    remove_column :newsletters, :custom4_body
    remove_column :newsletters, :custom4_title
  end
end
