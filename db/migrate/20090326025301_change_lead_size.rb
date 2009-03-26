class ChangeLeadSize < ActiveRecord::Migration
  def self.up
    change_column :articles, :lead, :string, :size => 500
    change_column :how_tos, :summary, :string, :size => 500
  end

  def self.down
    change_column :articles, :lead, :string
    change_column :how_tos, :summary, :string
  end
end
