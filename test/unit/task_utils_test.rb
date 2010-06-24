require File.dirname(__FILE__) + '/../test_helper'

class TaskUtilsTest < ActiveSupport::TestCase
	fixtures :all

  def test_send_weekly_admin_stats
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    
    TaskUtils.send_weekly_admin_stats
    
    assert_equal User.admins.size, ActionMailer::Base.deliveries.size
  end

  def test_recompute_resident_experts
    TaskUtils.recompute_resident_experts
  end
  
  def test_send_offers_reminder_so
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    hasnt_created_offer = Factory(:user, :email => "hasnt_created_offer@test.com", :paid_special_offers => 1, :paid_special_offers_next_date_check => 6.months.from_now)
    
    has_received_reminder_recently = Factory(:user, :email => "has_received_reminder_recently@test.com", :offers_reminder_sent_at => 2.weeks.ago, :paid_special_offers => 1, :paid_special_offers_next_date_check => 6.months.from_now)
    
    expired_offers = Factory(:user, :email => "expired_offers@test.com", :paid_special_offers => 1, :paid_special_offers_next_date_check => 2.weeks.ago)
    
    has_changed_offer_recently = Factory(:user, :email => "has_changed_offer_recently@test.com", :paid_special_offers => 1, :paid_special_offers_next_date_check => 6.months.from_now)
    recent_so = Factory(:special_offer, :published_at => 2.weeks.ago, :author => has_changed_offer_recently)
    
    hasnt_changed_offer_recently = Factory(:user, :email => "hasnt_changed_offer_recently@test.com", :paid_special_offers => 1, :paid_special_offers_next_date_check => 6.months.from_now)
    old_so = Factory(:special_offer, :published_at => 6.weeks.ago, :author => hasnt_changed_offer_recently )
    
    TaskUtils.send_offers_reminder
    assert_equal 2, ActionMailer::Base.deliveries.size
    assert ActionMailer::Base.deliveries.map(&:to).flatten.include?(hasnt_created_offer.email)
    assert ActionMailer::Base.deliveries.map(&:to).flatten.include?(hasnt_changed_offer_recently.email)    
  end
  
  def test_send_offers_reminder_gv
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    hasnt_created_offer = Factory(:user, :email => "hasnt_created_offer@test.com", :paid_gift_vouchers => 1, :paid_gift_vouchers_next_date_check => 6.months.from_now)
    
    expired_offers = Factory(:user, :email => "expired_offers@test.com", :paid_gift_vouchers => 1, :paid_gift_vouchers_next_date_check => 2.weeks.ago)
    
    has_changed_offer_recently = Factory(:user, :email => "has_changed_offer_recently@test.com", :paid_gift_vouchers => 1, :paid_gift_vouchers_next_date_check => 6.months.from_now)
    recent_gv = Factory(:gift_voucher, :published_at => 2.weeks.ago, :author => has_changed_offer_recently)
    
    hasnt_changed_offer_recently = Factory(:user, :email => "hasnt_changed_offer_recently@test.com", :paid_gift_vouchers => 1, :paid_gift_vouchers_next_date_check => 6.months.from_now)
    old_gv = Factory(:gift_voucher, :published_at => 6.weeks.ago, :author => hasnt_changed_offer_recently )
    
    TaskUtils.send_offers_reminder
    assert_equal 2, ActionMailer::Base.deliveries.size
    assert ActionMailer::Base.deliveries.map(&:to).flatten.include?(hasnt_created_offer.email)
    assert ActionMailer::Base.deliveries.map(&:to).flatten.include?(hasnt_changed_offer_recently.email)    
      
    ActionMailer::Base.deliveries = []
    TaskUtils.send_offers_reminder
    assert_equal 0, ActionMailer::Base.deliveries.size, "Reminders should only be sent once"
    
  end
  
  def test_generate_autocomplete_subcategories
    TaskUtils.generate_autocomplete_subcategories
  end
  
  def test_generate_autocomplete_subcategories_content
    fm = Factory(:role)
    user_with_quote = Factory(:user, :last_name => "O'Neil")
    user_with_quote.roles << fm
    profile = Factory(:user_profile, :user => user_with_quote )
    s = ""
    assert User.full_members.published.include?(user_with_quote)
    TaskUtils.generate_autocomplete_subcategories_content(s)
    assert_match %r{O\\'Neil}, s, "Single quotes should be escaped"
  end

  def test_notify_unpublished_users
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    sub = Factory(:subcategory)
    user = Factory(:user, :subcategory1_id => sub.id, :notify_unpublished => true)
    user_event = Factory(:user_event, :event_type => UserEvent::VISIT_SUBCATEGORY, :subcategory_id => sub.id, :logged_at => 3.days.ago)
    user_event2 = Factory(:user_event, :event_type => UserEvent::VISIT_SUBCATEGORY, :subcategory_id => sub.id, :logged_at => 3.days.ago)
    user_event3 = Factory(:user_event, :event_type => UserEvent::VISIT_SUBCATEGORY, :subcategory_id => sub.id, :logged_at => 3.days.ago)
    user_event4 = Factory(:user_event, :event_type => UserEvent::VISIT_SUBCATEGORY, :subcategory_id => sub.id, :logged_at => 3.days.ago)
    user_event5 = Factory(:user_event, :event_type => UserEvent::VISIT_SUBCATEGORY, :subcategory_id => sub.id, :logged_at => 3.days.ago)
    user_event6 = Factory(:user_event, :event_type => UserEvent::VISIT_SUBCATEGORY, :subcategory_id => sub.id, :logged_at => 3.days.ago)
    user_event7 = Factory(:user_event, :event_type => UserEvent::VISIT_SUBCATEGORY, :subcategory_id => sub.id, :logged_at => 3.days.ago)
    
    TaskUtils.notify_unpublished_users

    assert_equal 0, ActionMailer::Base.deliveries.size
    
    user_event8 = Factory(:user_event, :event_type => UserEvent::VISIT_SUBCATEGORY, :subcategory_id => sub.id, :logged_at => 3.days.ago)
    
    TaskUtils.notify_unpublished_users
    
    assert_equal 1, ActionMailer::Base.deliveries.size
    new_email = ActionMailer::Base.deliveries.first
    assert_equal [user.email], new_email.to
    assert_match %r{8 people have visited our #{sub.name} page}, new_email.body
  end

  def test_check_pending_payments
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    
    TaskUtils.check_pending_payments
    
    assert_equal 1, ActionMailer::Base.deliveries.size
    
    ActionMailer::Base.deliveries = []

    TaskUtils.check_pending_payments
    
    assert_equal 0, ActionMailer::Base.deliveries.size
    
  end

  def test_check_feature_expiration_gift_vouchers
    user_expired_gift_vouchers = Factory(:user, :paid_gift_vouchers => 3, :paid_gift_vouchers_next_date_check => 1.month.ago )
    order_secial_offers1 = Factory(:order, :gift_vouchers => 1, :created_at => 13.months.ago, :user_id => user_expired_gift_vouchers.id )
    order_secial_offers2 = Factory(:order, :gift_vouchers => 1, :created_at => 6.months.ago, :user_id => user_expired_gift_vouchers.id )
    order_secial_offers3 = Factory(:order, :gift_vouchers => 1, :created_at => 3.months.ago, :user_id => user_expired_gift_vouchers.id )
    
    gv1 = Factory(:gift_voucher, :author => user_expired_gift_vouchers )
    gv1.publish!
    gv2 = Factory(:gift_voucher, :author => user_expired_gift_vouchers )
    gv2.publish!
    gv3 = Factory(:gift_voucher, :author => user_expired_gift_vouchers )
    gv3.publish!
    
    old_next_check = user_expired_gift_vouchers.paid_gift_vouchers_next_date_check
    assert_equal 2, user_expired_gift_vouchers.orders.not_expired.size
    assert_equal 3, user_expired_gift_vouchers.paid_gift_vouchers
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    
    TaskUtils.check_feature_expiration
    
    assert_equal 2, ActionMailer::Base.deliveries.size, "Should be 1 email to user with expired gift voucher + 1 alert to Megan"
    user_expired_gift_vouchers.reload
    assert old_next_check < user_expired_gift_vouchers.paid_gift_vouchers_next_date_check, "The next date check should have moved forward, but old_next_check is #{old_next_check} and the new one is #{user_expired_gift_vouchers.paid_gift_vouchers_next_date_check}"
    assert_in_delta 6.months.from_now.to_time.to_f, user_expired_gift_vouchers.paid_gift_vouchers_next_date_check.to_time.to_f, 60*60*24*2, "More or less (two day leeway to account for leap years)"
    email = ActionMailer::Base.deliveries.last
    assert_not_nil email
    assert_match /Time to renew/, email.subject
    
    assert_equal 2, user_expired_gift_vouchers.gift_vouchers.published.size, "There should be only 2 published gift vouchers left"
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
    
    assert_equal 2, ActionMailer::Base.deliveries.size, "Should be 1 email to user with expiring gift voucher + 1 alert to Megan"
    email = ActionMailer::Base.deliveries.last
    assert_not_nil email
    assert_match /Time to renew/, email.subject

    ActionMailer::Base.deliveries = []
    TaskUtils.check_feature_expiration
    
    assert_equal 0, ActionMailer::Base.deliveries.size, "Emails should not be sent again"
  end

  def test_check_feature_expiration_special_offers
    user_expired_special_offers = Factory(:user, :paid_special_offers => 3, :paid_special_offers_next_date_check => 1.month.ago )
    order_secial_offers1 = Factory(:order, :special_offers => 1, :created_at => 13.months.ago, :user_id => user_expired_special_offers.id )
    order_secial_offers2 = Factory(:order, :special_offers => 1, :created_at => 6.months.ago, :user_id => user_expired_special_offers.id )
    order_secial_offers3 = Factory(:order, :special_offers => 1, :created_at => 3.months.ago, :user_id => user_expired_special_offers.id )
    so1 = Factory(:special_offer, :author => user_expired_special_offers)
    so1.publish!
    so2 = Factory(:special_offer, :author => user_expired_special_offers)
    so2.publish!
    so3 = Factory(:special_offer, :author => user_expired_special_offers)
    so3.publish!
    old_next_check = user_expired_special_offers.paid_special_offers_next_date_check
    assert_equal 2, user_expired_special_offers.orders.not_expired.size
    assert_equal 3, user_expired_special_offers.paid_special_offers
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    
    TaskUtils.check_feature_expiration
    
    assert_equal 2, ActionMailer::Base.deliveries.size, "Should be 1 email to user with expired special offer + 1 alert to Megan"
    user_expired_special_offers.reload
    assert old_next_check < user_expired_special_offers.paid_special_offers_next_date_check, "The next date check should have moved forward, but old_next_check is #{old_next_check} and the new one is #{user_expired_special_offers.paid_special_offers_next_date_check}"
    assert_in_delta 6.months.from_now.to_time.to_f, user_expired_special_offers.paid_special_offers_next_date_check.to_time.to_f, 60*60*24*2, "More or less (two day leeway to account for leap years)"
    email = ActionMailer::Base.deliveries.last
    assert_not_nil email
    assert_match /Time to renew/, email.subject
    
    assert_equal 2, user_expired_special_offers.special_offers.published.size, "There should be only 2 published special offers left"
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
    
    assert_equal 2, ActionMailer::Base.deliveries.size, "Should be 1 email to user with expiring special offer + 1 alert to Megan"
    email = ActionMailer::Base.deliveries.last
    assert_not_nil email
    assert_match /Time to renew/, email.subject
  end

  def test_check_feature_expiration_expired_photo
    user_expired_photo = Factory(:user, :paid_photo => true, :paid_photo_until => 1.month.ago )
    assert user_expired_photo.paid_photo?
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    
    TaskUtils.check_feature_expiration
    
    assert_equal 2, ActionMailer::Base.deliveries.size, "Should be 1 email to user with expired photo + 1 alert to Megan"

    ActionMailer::Base.deliveries = []
    TaskUtils.check_feature_expiration
    assert_equal 0, ActionMailer::Base.deliveries.size, "The expired photo email should only be sent once"    
  end

  def test_check_feature_expiration_has_expired_photo
    user_expired_photo = Factory(:user, :paid_photo => false, :paid_photo_until => 4.days.ago, :feature_warning_sent => 7.days.ago  )
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    
    TaskUtils.check_feature_expiration
    
    assert_equal 1, ActionMailer::Base.deliveries.size, "should be 1 email to user with expired photo"
    ActionMailer::Base.deliveries = []
    
    TaskUtils.check_feature_expiration
    
    assert_equal 0, ActionMailer::Base.deliveries.size, "Email should not be sent again"
  end

  def test_check_feature_expiration_has_expired_photo_false
    user_expired_photo = Factory(:user, :paid_photo => false, :paid_photo_until => 2.days.ago )
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    
    TaskUtils.check_feature_expiration
    
    assert_equal 0, ActionMailer::Base.deliveries.size, "No email as we have not reached the 3 day threshold yet"
  end

  def test_check_feature_expiration_expired_multiple_features
    user_expired_photo = Factory(:user, :paid_photo => true, :paid_photo_until => 1.month.ago, :paid_highlighted => true, :paid_highlighted_until => 1.month.ago )
    assert user_expired_photo.paid_highlighted?
    assert user_expired_photo.paid_photo?
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    
    TaskUtils.check_feature_expiration
    
    assert_equal 2, ActionMailer::Base.deliveries.size, "Should be 1 email to user with expired photo + 1 alert to Megan"
    email = ActionMailer::Base.deliveries.last
    assert_not_nil email
    assert_match /photo/, email.body
    assert_match /highlighted profile/, email.body
    
    ActionMailer::Base.deliveries = []
    TaskUtils.check_feature_expiration
    assert_equal 0, ActionMailer::Base.deliveries.size, "The expiring features email should only be sent once"    
  end

  def test_check_feature_expiration_expiring_photo
    user_expired_photo = Factory(:user, :paid_photo => true, :paid_photo_until => 6.days.from_now )
    assert user_expired_photo.paid_photo?
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    
    TaskUtils.check_feature_expiration
    
    assert_equal 2, ActionMailer::Base.deliveries.size, "Should be 1 email to user with expiring photo + 1 alert to Megan"
    
    ActionMailer::Base.deliveries = []
    TaskUtils.check_feature_expiration
    assert_equal 0, ActionMailer::Base.deliveries.size, "The expiring photo feature email should only be sent once"
  end

  def test_check_feature_expiration_expired_highlighted
    user_expired_photo = Factory(:user, :paid_highlighted => true, :paid_highlighted_until => 1.month.ago )
    assert user_expired_photo.paid_highlighted?
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    
    TaskUtils.check_feature_expiration
    
    assert_equal 2, ActionMailer::Base.deliveries.size, "Should be 1 email to user with expired highlighted + 1 alert to Megan"

    ActionMailer::Base.deliveries = []
    TaskUtils.check_feature_expiration
    assert_equal 0, ActionMailer::Base.deliveries.size, "The expired feature email should only be sent once"
    
  end

  def test_check_feature_expiration_expiring_highlighted
    user_expired_photo = Factory(:user, :paid_highlighted => true, :paid_highlighted_until => 6.days.from_now )
    assert user_expired_photo.paid_highlighted?
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    
    TaskUtils.check_feature_expiration
    
    assert_equal 2, ActionMailer::Base.deliveries.size, "Should be 1 email to user with expiring highlighted + 1 alert to Megan"
    
    ActionMailer::Base.deliveries = []
    TaskUtils.check_feature_expiration
    assert_equal 0, ActionMailer::Base.deliveries.size, "The expiring highlighted email should only be sent once"    
  end

  def test_rotate_feature_ranks
    fm_role = Factory(:role)
    user1 = Factory(:user, :paid_photo => true, :membership_type => "full_member")
    # user1.roles << fm_role
    user1.user_profile.update_attribute(:state, "published")
    user2 = Factory(:user, :paid_photo => true, :membership_type => "full_member")
    # user2.roles << fm_role
    user2.user_profile.update_attribute(:state, "published")
    assert !user2.free_listing?
    cyrille = users(:cyrille)
    old_updated_at = cyrille.updated_at
    norma = users(:norma)
    norma.paid_photo = true
    norma.paid_highlighted = true
    norma.save!
    norma.reload
    TaskUtils.rotate_feature_ranks
    assert User.published.active.full_members.size > User::DAILY_USER_ROTATION, "Should have at least #{User::DAILY_USER_ROTATION} users, otherwise the rotation is meaningless"
    User.published.active.full_members.each do |u|
      assert_not_nil u.feature_rank, "Feature should not be nil for user #{u.name}" if u.paid_photo?
    end
    cyrille.reload
    rank = cyrille.feature_rank
    TaskUtils.rotate_feature_ranks
    cyrille.reload
    assert cyrille.feature_rank != rank, "Feature should have changed"
    assert_equal old_updated_at, cyrille.updated_at, "User updated_at should not have changed, as this is not really a change to the user, but just s change of rank. We use update_attribute_without_timestamping to achieve this"
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
		hypnotherapy.reload
		assert_equal 5, hypnotherapy.users_counter
		practitioners.reload
		assert_equal 8, practitioners.users_counter
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
    #Sav exists in users
    sav = User.find_by_email("sav@elevatecoaching.co.nz")
    assert_not_nil sav
    assert sav.admin?
    assert !sav.free_listing?
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
