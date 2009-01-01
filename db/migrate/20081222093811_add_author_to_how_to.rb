class AddAuthorToHowTo < ActiveRecord::Migration
  def self.up
    add_column :how_tos, :author_id, :integer
  end

  def self.down
    remove_column :how_tos, :author_id
  end
end
