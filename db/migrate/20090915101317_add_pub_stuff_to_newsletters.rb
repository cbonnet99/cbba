class AddPubStuffToNewsletters < ActiveRecord::Migration
  def self.up
    add_column :newsletters, :state, :string
    add_column :newsletters, :published_at, :datetime
    add_column :newsletters, :publisher_id, :integer
    add_column :newsletters, :author_id, :integer
  end

  def self.down
    remove_column :newsletters, :author_id
    remove_column :newsletters, :publisher_id
    remove_column :newsletters, :published_at
    remove_column :newsletters, :state
  end
end
