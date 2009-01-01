class AddSlugToHowTos < ActiveRecord::Migration
  def self.up
    add_column :how_tos, :slug, :string
  end

  def self.down
    remove_column :how_tos, :slug
  end
end
