class MoveFullMembersToNewPaidFeatures < ActiveRecord::Migration
  def self.up
    User.full_members.each do |u|
      if !u.valid?
        if u.admin?
          puts "Warning: can't update admin user: #{u.name}"
        else
          puts "ERROR: can't update user: #{u.name}"
        end
      else
        u.paid_photo = true
        u.paid_photo_until = u.member_until
        u.paid_highlighted = true
        u.paid_highlighted_until = u.member_until
        u.paid_special_offers = 1
        u.paid_special_offers_next_date_check = u.member_until
        u.paid_gift_vouchers = 1
        u.paid_gift_vouchers_next_date_check = u.member_until
        u.save!
      
        #create an order
        u.orders.create(:photo => true, :highlighted => true, :special_offers => 1, :gift_vouchers => 1, :whole_package => true,
                        :created_at => u.member_until.nil? ? nil : u.member_until-1.year,
                        :updated_at => u.member_until.nil? ? nil : u.member_until-1.year, :state => "paid" )
      end
    end
  end

  def self.down
  end
end
