class AddStateToHowTos < ActiveRecord::Migration
  def self.up
    add_column :how_tos, :state, :string, :default => 'draft'
  end

  def self.down
    remove_column :how_tos, :state
  end
end
