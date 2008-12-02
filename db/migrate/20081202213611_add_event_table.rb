class AddEventTable < ActiveRecord::Migration
  def self.up
    create_table :user_events do |t|
      t.column  :source_url, :string
      t.column  :destination_url, :string
      t.column  :remote_ip, :string
      t.column  :logged_at, :datetime
      t.column  :extra_data, :text
      t.column  :event_type, :string
      t.column :user_id, :integer
      t.column :article_id, :integer
      t.column :category_id, :integer
      t.column :subcategory_id, :integer
      t.column :region_id, :integer
      t.column :district_id, :integer
    end
  end

  def self.down
    drop_table :user_events
  end
end
