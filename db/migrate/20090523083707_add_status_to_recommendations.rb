class AddStatusToRecommendations < ActiveRecord::Migration
  def self.up
    add_column :recommendations, :status, :string
  end

  def self.down
    remove_column :recommendations, :status
  end
end
