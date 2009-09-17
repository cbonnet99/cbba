class AddFeatureRankToHowTos < ActiveRecord::Migration
  def self.up
    add_column :how_tos, :feature_rank, :integer
  end

  def self.down
    remove_column :how_tos, :feature_rank
  end
end
