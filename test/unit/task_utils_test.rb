require File.dirname(__FILE__) + '/../test_helper'

class TaskUtilsTest < ActiveSupport::TestCase
	fixtures :all

  def test_check_feature_expiration_gift_vouchers
    user_expired_gift_vouchers = Factory(:user, :paid_gift_vouchers => 3, :paid_gift_vouchers_next_date_check => 1.month.ago )
    order_secial_offers1 = Factory(:order, :gift_vouchers => 1, :created_at => 13.months.ago, :user_id => user_expired_gift_vouchers.id )
    order_secial_offers2 = Factory(:order, :gift_vouchers => 1, :created_at => 6.months.ago, :user_id => user_expired_gift_vouchers.id )
    order_secial_offers3 = Factory(:order, :gift_vouchers => 1, :created_at => 3.months.ago, :user_id => user_expired_gift_vouchers.id )
    old_next_check = user_expired_gift_vouchers.paid_gift_vouchers_next_date_check
    assert_equal 2, user_expired_gift_vouchers.orders.not_expired.size
    assert_equal 3, user_expired_gift_vouchers.paid_gift_vouchers
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    
    TaskUtils.check_feature_expiration
    
    assert_equal 1, ActionMailer::Base.deliveries.size, "Should be 1 email to user with expired gift voucher"
    user_expired_gift_vouchers.reload
    assert old_next_check < user_expired_gift_vouchers.paid_gift_vouchers_next_date_check, "The next date check should have moved forward, but old_next_check is #{old_next_check} and the new one is #{user_expired_gift_vouchers.paid_gift_vouchers_next_date_check}"
    assert_in_delta 6.months.from_now.to_time.to_f, user_expired_gift_vouchers.paid_gift_vouchers_next_date_check.to_time.to_f, 60*60*24*2, "More or less (two day leeway to account for leap years)"
    email = ActionMailer::Base.deliveries.first
    assert_not_nil email
    assert_match /gift voucher/, email.subject
  end

  def test_check_feature_expiring_gift_vouchers
    user_expired_gift_vouchers = Factory(:user, :paid_gift_vouchers => 3, :paid_gift_vouchers_next_date_check => 3.days.from_now )
    order_secial_offers1 = Factory(:order, :gift_vouchers => 1, :created_at => 362.days.ago, :user_id => user_expired_gift_vouchers.id )
    order_secial_offers2 = Factory(:order, :gift_vouchers => 1, :created_at => 6.months.ago, :user_id => user_expired_gift_vouchers.id )
    order_secial_offers3 = Factory(:order, :gift_vouchers => 1, :created_at => 3.months.ago, :user_id => user_expired_gift_vouchers.id )
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    TaskUtils.check_feature_expiration
    
    assert_equal 1, ActionMailer::Base.deliveries.size, "Should be 1 email to user with expiring gift voucher"
    email = ActionMailer::Base.deliveries.first
    assert_not_nil email
    assert_match /gift voucher/, email.subject
  end

  def test_check_feature_expiration_special_offers
    user_expired_special_offers = Factory(:user, :paid_special_offers => 3, :paid_special_offers_next_date_check => 1.month.ago )
    order_secial_offers1 = Factory(:order, :special_offers => 1, :created_at => 13.months.ago, :user_id => user_expired_special_offers.id )
    order_secial_offers2 = Factory(:order, :special_offers => 1, :created_at => 6.months.ago, :user_id => user_expired_special_offers.id )
    order_secial_offers3 = Factory(:order, :special_offers => 1, :created_at => 3.months.ago, :user_id => user_expired_special_offers.id )
    old_next_check = user_expired_special_offers.paid_special_offers_next_date_check
    assert_equal 2, user_expired_special_offers.orders.not_expired.size
    assert_equal 3, user_expired_special_offers.paid_special_offers
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    
    TaskUtils.check_feature_expiration
    
    assert_equal 1, ActionMailer::Base.deliveries.size, "Should be 1 email to user with expired special offer"
    user_expired_special_offers.reload
    assert old_next_check < user_expired_special_offers.paid_special_offers_next_date_check, "The next date check should have moved forward, but old_next_check is #{old_next_check} and the new one is #{user_expired_special_offers.paid_special_offers_next_date_check}"
    assert_in_delta 6.months.from_now.to_time.to_f, user_expired_special_offers.paid_special_offers_next_date_check.to_time.to_f, 60*60*24*2, "More or less (two day leeway to account for leap years)"
    email = ActionMailer::Base.deliveries.first
    assert_not_nil email
    assert_match /special offer/, email.subject
  end

  def test_check_feature_expiring_special_offers
    user_expired_special_offers = Factory(:user, :paid_special_offers => 3, :paid_special_offers_next_date_check => 3.days.from_now )
    order_secial_offers1 = Factory(:order, :special_offers => 1, :created_at => 362.days.ago, :user_id => user_expired_special_offers.id )
    order_secial_offers2 = Factory(:order, :special_offers => 1, :created_at => 6.months.ago, :user_id => user_expired_special_offers.id )
    order_secial_offers3 = Factory(:order, :special_offers => 1, :created_at => 3.months.ago, :user_id => user_expired_special_offers.id )
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    TaskUtils.check_feature_expiration
    
    assert_equal 1, ActionMailer::Base.deliveries.size, "Should be 1 email to user with expiring special offer"
    email = ActionMailer::Base.deliveries.first
    assert_not_nil email
    assert_match /special offer/, email.subject
  end

  def test_check_feature_expiration_expired_photo
    user_expired_photo = Factory(:user, :paid_photo => true, :paid_photo_until => 1.month.ago )
    assert user_expired_photo.paid_photo?
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    
    TaskUtils.check_feature_expiration
    
    assert_equal 1, ActionMailer::Base.deliveries.size, "Should be 1 email to user with expired photo"
  end

  def test_check_feature_expiration_expiring_photo
    user_expired_photo = Factory(:user, :paid_photo => true, :paid_photo_until => 6.days.from_now )
    assert user_expired_photo.paid_photo?
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    
    TaskUtils.check_feature_expiration
    
    assert_equal 1, ActionMailer::Base.deliveries.size, "Should be 1 email to user with expiring photo"
  end

  def test_check_feature_expiration_expired_highlighted
    user_expired_photo = Factory(:user, :paid_highlighted => true, :paid_highlighted_until => 1.month.ago )
    assert user_expired_photo.paid_highlighted?
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    
    TaskUtils.check_feature_expiration
    
    assert_equal 1, ActionMailer::Base.deliveries.size, "Should be 1 email to user with expired highlighted"
  end

  def test_check_feature_expiration_expiring_highlighted
    user_expired_photo = Factory(:user, :paid_highlighted => true, :paid_highlighted_until => 6.days.from_now )
    assert user_expired_photo.paid_highlighted?
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    
    TaskUtils.check_feature_expiration
    
    assert_equal 1, ActionMailer::Base.deliveries.size, "Should be 1 email to user with expiring highlighted"
  end

  def test_rotate_feature_ranks
    cyrille = users(:cyrille)
    TaskUtils.rotate_feature_ranks
    User.published.active.full_members.each do |u|
      assert_not_nil u.feature_rank, "Feature should not be nil for user #{u.name}"
    end
    cyrille.reload
    rank = cyrille.feature_rank
    TaskUtils.rotate_feature_ranks
    cyrille.reload
    assert cyrille.feature_rank != rank, "Feature should have changed"
  end

  def test_extract_numbers_from_reference
    assert_equal ["123", "234"], TaskUtils.extract_numbers_from_reference("123-INV-234")
    assert_equal ["123", "234"], TaskUtils.extract_numbers_from_reference("123 inv.234")
  end

  def test_imports
		ImportUtils.import_roles
		ImportUtils.import_districts
		ImportUtils.import_categories
		ImportUtils.import_subcategories
    TaskUtils.create_default_admins
		ImportUtils.import_users("small_users.csv")
		
		life_coaching = Subcategory.find(:all, :conditions => ["LOWER(name) = 'life coaching'"])
		assert_not_nil life_coaching
		assert_equal 1, life_coaching.size
		
		wrong_life_coaching = Subcategory.find(:all, :conditions => ["LOWER(name) = 'lifecoaching'"])
		assert wrong_life_coaching.blank?
		
		health_centres = Category.find(:all, :conditions => ["LOWER(name) = 'health centres'"])
		assert_equal 1, health_centres.size
		#Health centres should be lowercase c (as it is displayed that way on left nav)
		health_centres = Category.find(:all, :conditions => ["name = 'Health centres'"])
		assert_equal 1, health_centres.size
  end


  def test_process_paid_xero_invoices
    TaskUtils.process_paid_xero_invoices
  end

  def test_generate_random_passwords
    TaskUtils.generate_random_passwords
  end

  def test_mark_down_old_expert_applications
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    
    applying_expert_without_payment = expert_applications(:applying_expert_without_payment)
    assert_not_nil applying_expert_without_payment.approved_by_id
    assert_not_nil applying_expert_without_payment.approved_at
    
    TaskUtils.mark_down_old_expert_applications
    applying_expert_without_payment.reload
    assert_nil applying_expert_without_payment.approved_at
    assert_nil applying_expert_without_payment.approved_by_id
    assert applying_expert_without_payment.pending?

    assert_equal 1, ActionMailer::Base.deliveries.size

  end

  def test_update_counters
    full_members = counters(:full_members)
    resident_experts = counters(:resident_experts)
    special_offers = counters(:special_offers)
    gift_vouchers = counters(:gift_vouchers)
    TaskUtils.update_counters
    full_members.reload
    assert_equal 2, full_members.count
    resident_experts.reload
    assert_equal 1, resident_experts.count
  end

  def test_send_reminder_on_expiring_memberships
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    
    TaskUtils.send_reminder_on_expiring_memberships
    assert_equal 4, ActionMailer::Base.deliveries.size
    
    #on 2nd run there should be no emails sent
    ActionMailer::Base.deliveries = []
    TaskUtils.send_reminder_on_expiring_memberships
    assert_equal 0, ActionMailer::Base.deliveries.size
  end

  def test_suspend_full_members_when_membership_expired
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    old_user_emails_size = UserEmail.all.size

    sgardiner = users(:sgardiner)
    old_size = User.active.size
    TaskUtils.suspend_full_members_when_membership_expired
    #no full member to suspend
    assert_equal old_size, User.active.size
    sgardiner.member_until = 1.day.ago
    sgardiner.save!
    sgardiner.reload
    TaskUtils.suspend_full_members_when_membership_expired

    sgardiner.reload
    #sgardiner should have been suspended
    assert_equal old_size-1, User.active.size
    #an email should have been sent to sgardiner
    assert_equal 1, ActionMailer::Base.deliveries.size

    assert_equal old_user_emails_size+1, UserEmail.all.size
    last_email = UserEmail.last
    assert_equal "membership_expired_today", last_email.email_type
    assert_equal sgardiner, last_email.user

  end

  def test_suspend_resident_experts_when_membership_expired
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    old_user_emails_size = UserEmail.all.size

    cyrille = users(:cyrille)
    old_size = User.active.size
    TaskUtils.suspend_full_members_when_membership_expired
    #no full member to suspend
    assert_equal old_size, User.active.size
    cyrille.resident_until = 1.day.ago
    cyrille.save!
    cyrille.reload
    TaskUtils.suspend_full_members_when_membership_expired

    cyrille.reload
    #Cyrille should have been suspended
    assert_equal old_size-1, User.active.size
    #an email should have been sent to Cyrille
    assert_equal 1, ActionMailer::Base.deliveries.size

    assert_equal old_user_emails_size+1, UserEmail.all.size
    last_email = UserEmail.last
    assert_equal "residence_expired_today", last_email.email_type
    assert_equal cyrille, last_email.user

  end

  def test_mark_down_old_full_members
    norma = users(:norma)
    rmoore = users(:rmoore)
    assert norma.new_user?
    assert rmoore.new_user?
    TaskUtils.mark_down_old_full_members
    norma.reload
    assert !norma.new_user?
    assert rmoore.new_user?

  end

	def test_count_users
		practitioners = categories(:practitioners)
		hypnotherapy = subcategories(:hypnotherapy)
		TaskUtils.count_users
		practitioners.reload
		assert_equal 7, practitioners.users_counter
		hypnotherapy.reload
		assert_equal 5, hypnotherapy.users_counter
	end

  def test_create_default_admins
    old_size = User.all.size
    TaskUtils.create_default_admins
    assert_equal old_size+$admins.size, User.all.size
    sav = User.find_by_email("sav@elevatecoaching.co.nz")
    assert_not_nil sav
    assert sav.admin?
    assert !sav.free_listing?
    cyrille = User.find_by_email("cbonnet99@gmail.com")
    assert_not_nil cyrille
    assert cyrille.admin?
    assert_nil cyrille.district
    assert_nil cyrille.subcategory1_id
    assert_nil cyrille.latitude
    assert_nil cyrille.longitude
  end

  def test_create_default_admins_after_import_users
    ImportUtils.import_districts
    ImportUtils.import_users("small_users.csv")
    TaskUtils.create_default_admins
    #Norma exists in users
    norma = User.find_by_email("norma@eurekacoaching.co.nz")
    assert_not_nil norma
    assert norma.admin?
    assert !norma.free_listing?
  end

    def test_rotate_user_positions_in_subcategories
      canterbury = regions(:canterbury)
      canterbury_christchurch_city = districts(:canterbury_christchurch_city)
      hypnotherapy = subcategories(:hypnotherapy)
      results = User.search_results(nil, hypnotherapy.id, canterbury.id, nil, 1)
  #     puts "============= results:"
  #     results.each do |r|
  #       puts "#{r.name}  - #{r.free_listing}- #{r.id}"
  #       r.subcategories_users.each do |su|
  #         puts "+++++++++ #{su.subcategory_id} - #{su.position}"
  #       end
  #     end

      TaskUtils.rotate_user_positions_in_subcategories
      new_results = User.search_results(nil, hypnotherapy.id, canterbury.id, nil, 1)
      new_results_size = new_results.size
      # #first full member should have changed
      assert new_results.first != results.first

  #     puts "============= new_results:"
  #     new_results.each do |r|
  #       puts "#{r.name}  - #{r.free_listing}- #{r.id}"
  #       r.subcategories_users.each do |su|
  #         puts "+++++++++ #{su.subcategory_id} - #{su.position}"
  #       end
  #     end
      old_user_size = User.all.size
      # #another hypnoptherapist in Chrischurch!
      user = User.new(:first_name => "Joe", :last_name => "Test", :district_id => canterbury_christchurch_city.id,
        :region_id => canterbury.id, :email => "joe@test.com",
        :membership_type => "full_member", :professional => true, :subcategory1_id => hypnotherapy.id,
        :password => "blablabla", :password_confirmation => "blablabla" )
      user.register!

      user.activate!
      user.subcategories_users.reload
      assert_equal 1, user.subcategories_users.size
      assert_equal old_user_size+1, User.all.size
      after_insert_results = User.search_results(nil, hypnotherapy.id, canterbury.id, nil, 1)
      #the new user should be the last of the full members
  #    puts "============= after_insert_results:"
  #    after_insert_results.each do |r|
  #      puts "#{r.name}  - #{r.free_listing}"
  #       r.subcategories_users.each do |su|
  #         puts "+++++++++ #{su.subcategory_id} - #{su.position}"
  #       end
  #    end

      #only one result should have been added
      assert_equal new_results_size+1, after_insert_results.size
      assert after_insert_results.first == new_results.first

      last_full_member_new = new_results.select{|m| !m.free_listing?}.last
      last_full_member_after_insert = after_insert_results.select{|m| !m.free_listing?}.last
      assert last_full_member_new != last_full_member_after_insert
    end
    def test_rotate_user_positions_in_categories
      canterbury = regions(:canterbury)
      canterbury_christchurch_city = districts(:canterbury_christchurch_city)
      practitioners = categories(:practitioners)
      results = User.search_results(practitioners.id, nil, canterbury.id, nil, 1)
  #     puts "============= results:"
  #     results.each do |r|
  #       puts "#{r.name}  - #{r.free_listing}- #{r.id}"
  #       r.subcategories_users.each do |su|
  #         puts "+++++++++ #{su.subcategory_id} - #{su.position}"
  #       end
  #     end

      TaskUtils.rotate_user_positions_in_categories
      new_results = User.search_results(practitioners.id, nil, canterbury.id, nil, 1)
      new_results_size = new_results.size
      # #first full member should have changed
      assert new_results.first != results.first

  #     puts "============= new_results:"
  #     new_results.each do |r|
  #       puts "#{r.name}  - #{r.free_listing}- #{r.id}"
  #       r.subcategories_users.each do |su|
  #         puts "+++++++++ #{su.subcategory_id} - #{su.position}"
  #       end
  #     end
      old_user_size = User.all.size
      # #another hypnoptherapist in Chrischurch!
      user = User.new(:first_name => "Joe", :last_name => "Test", :district_id => canterbury_christchurch_city.id,
        :region_id => canterbury.id, :email => "joe@test.com",
        :membership_type => "full_member", :professional => true, :subcategory1_id => subcategories(:hypnotherapy).id,
        :password => "blablabla", :password_confirmation => "blablabla" )
      user.register!

      user.activate!
      user.categories_users.reload
      assert_equal 1, user.categories_users.size
      assert_equal old_user_size+1, User.all.size
      after_insert_results = User.search_results(practitioners.id, nil, canterbury.id, nil, 1)
      #the new user should be the last of the full members
  #    puts "============= after_insert_results:"
  #    after_insert_results.each do |r|
  #      puts "#{r.name}  - #{r.free_listing}"
  #       r.subcategories_users.each do |su|
  #         puts "+++++++++ #{su.subcategory_id} - #{su.position}"
  #       end
  #    end

      #only one result should have been added
      assert_equal new_results_size+1, after_insert_results.size
      assert after_insert_results.first == new_results.first

      last_full_member_new = new_results.select{|m| !m.free_listing?}.last
      last_full_member_after_insert = after_insert_results.select{|m| !m.free_listing?}.last
      assert last_full_member_new != last_full_member_after_insert
    end
end
