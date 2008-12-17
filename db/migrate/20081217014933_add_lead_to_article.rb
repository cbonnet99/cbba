class AddLeadToArticle < ActiveRecord::Migration
  def self.up
    add_column :articles, :lead, :string
  end

  def self.down
    remove_column :articles, :lead
  end
end
