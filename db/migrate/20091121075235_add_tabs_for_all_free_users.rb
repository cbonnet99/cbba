class AddTabsForAllFreeUsers < ActiveRecord::Migration
  def self.up
    User.free_users.each do |u|
      if u.tabs.blank?
        u.add_tabs
      end
    end
  end

  def self.down
  end
end
