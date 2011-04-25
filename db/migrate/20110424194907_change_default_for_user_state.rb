class ChangeDefaultForUserState < ActiveRecord::Migration
  def self.up
    change_column_default :users, :state, "unconfirmed"
  end

  def self.down
    change_column_default :users, :state, "passive"
  end
end
