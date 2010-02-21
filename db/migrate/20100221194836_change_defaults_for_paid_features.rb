class ChangeDefaultsForPaidFeatures < ActiveRecord::Migration
  def self.up
    change_column_default(:users, :paid_photo, false)
    change_column_default(:users, :paid_highlighted, false)
  end

  def self.down
  end
end
