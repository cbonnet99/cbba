class UpgradeAllFreeUsersToFullMembers < ActiveRecord::Migration
  def self.up
    User.full_members.each do |fm|
      unless fm.name == "Cyrille Bonnet"
        fm.paid_photo = true
        fm.paid_photo_until = fm.member_until
        fm.paid_highlighted = true
        fm.paid_highlighted_until = fm.member_until
        fm.paid_special_offers = 1
        fm.paid_special_offers_next_date_check = fm.member_until
        fm.paid_gift_vouchers = 1
        fm.paid_gift_vouchers_next_date_check = fm.member_until
        puts "==== Adding paid features to #{fm.full_name}"
        fm.save!
      end
    end
    
    User.free_users.each do |free|
      unless free.name == "Cyrille Bonnet"
        puts "==== Making #{free.full_name} a full member"
        free.update_attribute(:free_listing, false)
        free.add_role("full_member")
      end
    end
  end

  def self.down
  end
end
