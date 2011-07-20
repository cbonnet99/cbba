class ChangeContactToAuthor < ActiveRecord::Migration
  def self.up
    remove_column :questions, :contact_id
    add_column :questions, :author_id, :integer
  end

  def self.down
    remove_column :questions, :author_id
    add_column :questions, :contact_id, :integer
  end
end
