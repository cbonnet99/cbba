class UpgradeAllFreeUsersToFullMembers < ActiveRecord::Migration
  def self.up
    User.free_users.each do |free|
      free.update_attribute(:free_listing, false)
      free.add_role("full_member")
    end
  end

  def self.down
  end
end
