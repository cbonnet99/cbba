class AddResidentSinceResidentUntilToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :resident_since, :timestamp
    add_column :users, :resident_until, :timestamp
  end

  def self.down
    remove_column :users, :resident_until
    remove_column :users, :resident_since
  end
end
