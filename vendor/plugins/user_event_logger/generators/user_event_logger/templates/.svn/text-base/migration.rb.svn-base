class <%= class_name %> < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.column  :source_url, :string
      t.column  :destination_url, :string
      t.column  :remote_ip, :string
      t.column  :logged_at, :datetime
      t.column  :extra_data, :text
      t.column  :event_type, :string
    end
  end

  def self.down
    drop_table :events
  end
end
