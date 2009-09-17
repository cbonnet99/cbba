class AddFeatureRankToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :feature_rank, :integer
  end

  def self.down
    remove_column :users, :feature_rank
  end
end
