class ChangeColumnSizes < ActiveRecord::Migration
  def self.up
    change_column :how_tos, :summary, :string, :limit => 500 
    change_column :articles, :lead, :string, :limit => 500 
  end

  def self.down
    change_column :how_tos, :summary, :string, :limit => 255
    change_column :articles, :lead, :string, :limit => 255
  end
end
