class UpgradeAllFreeUsersToFullMembers < ActiveRecord::Migration
  def self.up    
    User.free_users.each do |free|
      unless free.name == "Cyrille Bonnet"
        puts "==== Making #{free.full_name} a full member"
        free.free_listing = false
        free.remove_role("free_listing")
        free.add_role("full_member")
        free.save!
        free.user_profile.published_at = nil
        if free.user_profile.published?
          free.user_profile.reject!
        else
          free.user_profile.save!
        end
      end
    end
  end

  def self.down
  end
end
