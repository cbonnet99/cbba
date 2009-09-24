class AddCustomStuffToNewsletters < ActiveRecord::Migration
  def self.up
    add_column :newsletters, :custom1_title, :string
    add_column :newsletters, :custom1_body, :text
    add_column :newsletters, :custom2_title, :string
    add_column :newsletters, :custom2_body, :text
  end

  def self.down
    remove_column :newsletters, :custom2_body
    remove_column :newsletters, :custom2_title
    remove_column :newsletters, :custom1_body
    remove_column :newsletters, :custom1_title
  end
end
