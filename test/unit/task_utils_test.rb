require File.dirname(__FILE__) + '/../test_helper'

class TaskUtilsTest < ActiveSupport::TestCase
	fixtures :all

  def test_email_users_will_be_deleted
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    user_will_be_deleted = Factory(:user, :created_at => 6.days.ago, :state => "unconfirmed")
    user_wont_be_deleted = Factory(:user, :created_at => 8.days.ago, :state => "unconfirmed")
    
    TaskUtils.email_users_will_be_deleted
    
    profile_will_be_deleted_email = ActionMailer::Base.deliveries.select {|email| email.subject == "Please confirm your profile on test.host or it will be deleted in one week"}
    assert_not_nil profile_will_be_deleted_email
    
  end

  def test_delete_old_unconfirmed_users_with_published_articles
    old_unconfirmed_with_article = Factory(:user, :state => "unconfirmed", :created_at => 17.days.ago)
    old_unconfirmed_without_article = Factory(:user, :state => "unconfirmed", :created_at => 17.days.ago)
    
    article = Factory(:article, :author => old_unconfirmed_with_article)
    
    remove_id = old_unconfirmed_without_article.id
    keep_id = old_unconfirmed_with_article.id
    
    TaskUtils.delete_old_unconfirmed_users
    
    assert_raise ActiveRecord::RecordNotFound do
       User.find(remove_id)
     end
    assert_not_nil User.find(keep_id)
  end


  
  def test_delete_old_unconfirmed_users
    old_unconfirmed = Factory(:user, :state => "unconfirmed", :created_at => 17.days.ago)
    recent_unconfirmed = Factory(:user, :state => "unconfirmed", :created_at => 2.days.ago)
    
    old_id = old_unconfirmed.id
    recent_id = recent_unconfirmed.id
    
    TaskUtils.delete_old_unconfirmed_users
    
    assert_raise ActiveRecord::RecordNotFound do
       User.find(old_id)
     end
    assert_not_nil User.find(recent_id)
  end

  def test_delete_old_unconfirmed_contacts
    old_unconfirmed = Factory(:contact, :state => "unconfirmed", :created_at => 17.days.ago)
    recent_unconfirmed = Factory(:contact, :state => "unconfirmed", :created_at => 2.days.ago)
    
    old_id = old_unconfirmed.id
    recent_id = recent_unconfirmed.id
    
    TaskUtils.delete_old_unconfirmed_users
    
    assert_raise ActiveRecord::RecordNotFound do
       Contact.find(old_id)
     end
    assert_not_nil Contact.find(recent_id)
  end
  
  def test_delete_old_user_events
    ue_old = Factory(:user_event, :logged_at => 7.months.ago)
    ue_new = Factory(:user_event, :logged_at => 5.months.ago)
    old_id = ue_old.id
    new_id = ue_new.id
    
    TaskUtils.delete_old_user_events
    
    assert_raise(ActiveRecord::RecordNotFound) {UserEvent.find(old_id)}
    assert_not_nil UserEvent.find(new_id)
  end
  
  def test_change_homepage_featured_quote
    q = Factory(:quote)
    TaskUtils.change_homepage_featured_quote
    featured_quotes = Quote.homepage_featured
    assert_equal 1, featured_quotes.size
  end

  def test_change_homepage_featured_resident_experts
    nz = countries(:nz)
    sub1 = Factory(:subcategory)
    sub2 = Factory(:subcategory)
    expert1 = Factory(:user, :subcategory1_id  => sub1.id, :paid_photo => true, :country => nz)
    expert2 = Factory(:user, :subcategory1_id  => sub1.id, :paid_photo => true, :country => nz)
    expert3 = Factory(:user, :subcategory1_id  => sub2.id, :paid_photo => true, :country => nz)
    expert4 = Factory(:user, :subcategory1_id  => sub2.id, :paid_photo => true, :country => nz)
    expert5 = Factory(:user, :subcategory1_id  => sub2.id, :paid_photo => true, :country => nz)

    article1 = Factory(:article, :author => expert1, :published_at => 2.days.ago, :state => "draft", :subcategory1_id => sub1.id)
    article1.publish!
    

    article2 = Factory(:article, :author => expert2, :published_at => 2.days.ago, :state => "draft", :subcategory1_id => sub1.id)
    article2.publish!

    article3 = Factory(:article, :author => expert3, :published_at => 2.days.ago, :state => "draft", :subcategory1_id => sub2.id)
    article3.publish!
    
    article4 = Factory(:article, :author => expert4, :published_at => 2.days.ago, :state => "draft", :subcategory1_id => sub2.id)
    article4.publish!
    
    article5 = Factory(:article, :author => expert5, :published_at => 2.days.ago, :state => "draft", :subcategory1_id => sub2.id)
    article5.publish!
    
    TaskUtils.recompute_resident_experts
    
    assert User.resident_experts(nz).size >= User::NUMBER_HOMEPAGE_FEATURED_RESIDENT_EXPERTS, 
      "Only #{User.resident_experts(nz).size} resident experts were found: #{User.resident_experts(nz).map(&:name).to_sentence}"

    TaskUtils.change_homepage_featured_resident_experts
    
    expert1.reload
    nz_experts = User.homepage_featured_resident_experts(nz)
    assert_equal User::NUMBER_HOMEPAGE_FEATURED_RESIDENT_EXPERTS, nz_experts.size,
        "Only #{nz_experts.size} featured resident experts were found: #{nz_experts.map(&:name).to_sentence}"
    featured_before = User.homepage_featured_resident_experts(nz)
    
    TaskUtils.change_homepage_featured_resident_experts
    
    featured_after = User.homepage_featured_resident_experts(nz)
    assert featured_after.include?(expert4)
  end

  def test_change_homepage_featured_article
    nz = countries(:nz)
    
    user_with_paid_photo = Factory(:user, :paid_photo => true, :country => nz)
    user_with_paid_photo.publish!
    article = Factory(:article, :author => user_with_paid_photo, :state => "draft")
    article.publish!
    
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    featured_before = Article.first_homepage_featured(nz)
    
    TaskUtils.change_homepage_featured_article
    
    featured_after = Article.first_homepage_featured(nz)
    assert_not_nil featured_after
    assert featured_before != featured_after
    assert_not_nil featured_after.last_homepage_featured_at
    assert_equal 1, ActionMailer::Base.deliveries.size
    email = ActionMailer::Base.deliveries.first
  end

  def test_check_inconsistent_tabs
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    TaskUtils.check_inconsistent_tabs
    
    assert_equal User.admins.size, ActionMailer::Base.deliveries.size
  end
    
  def test_send_weekly_admin_stats
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    
    TaskUtils.send_weekly_admin_stats
    
    assert_equal User.admins.size, ActionMailer::Base.deliveries.size
  end

  def test_recompute_resident_experts_mixing_subcat
    nz = countries(:nz)
    subcat1 = Factory(:subcategory)
    subcat2 = Factory(:subcategory)
    subcat3 = Factory(:subcategory)
    subcat4 = Factory(:subcategory)
    nz_expert = Factory(:user, :subcategory1_id => subcat1.id, :subcategory2_id => subcat2.id, :subcategory3_id => subcat3.id, :country => nz)
    
    expert_article = Factory(:article, :subcategory1_id => subcat4.id, :author => nz_expert, :state => "draft")
    expert_article.publish!
    
    TaskUtils.recompute_resident_experts
    
    nz_expert.reload
    assert_equal [subcat1, subcat2, subcat3], nz_expert.subcategories
  end

  def test_recompute_resident_experts
    nz = countries(:nz)
    au = countries(:au)
    yoga = subcategories(:yoga)
    nz_expert = Factory(:user, :subcategory1_id => yoga.id, :country => nz)
    expert_article = Factory(:article, :subcategory1_id => yoga.id, :author => nz_expert, :state => "draft")
    expert_article.publish!

    au_expert = Factory(:user, :subcategory1_id => yoga.id, :country => au)
    au_expert_article1 = Factory(:article, :subcategory1_id => yoga.id, :author => au_expert, :state => "draft")
    au_expert_article1.publish!
    au_expert_article2 = Factory(:article, :subcategory1_id => yoga.id, :author => au_expert, :state => "draft")
    au_expert_article2.publish!

    
    TaskUtils.recompute_resident_experts
    
    nz_expert.reload
    assert nz_expert.active?
    nz_experts = User.resident_experts(nz)
    assert nz_experts.size > 0
    nz_experts.each do |expert|
      assert expert.published_articles_count > 0, "Expert #{expert.full_name} has no published article..."
    end
    
    assert nz_experts.include?(nz_expert), "#{nz_expert.name} could not be found in #{nz_experts.map(&:name).to_sentence}"
    nz_yoga_su = nz_expert.subcategories_users.select{|su| su.subcategory_id == yoga.id}.first
    assert_equal 1, nz_yoga_su.expertise_position, "There is no better expert in NZ"
    au_yoga_su = au_expert.subcategories_users.select{|su| su.subcategory_id == yoga.id}.first
    assert_equal 1, au_yoga_su.expertise_position, "There is no better expert in Oz"
  end
  
  def test_send_offers_reminder_so
    hasnt_created_offer = Factory(:user, :email => "hasnt_created_offer@test.com", :paid_special_offers => 1, :paid_special_offers_next_date_check => 6.months.from_now)
    
    has_received_reminder_recently = Factory(:user, :email => "has_received_reminder_recently@test.com", :offers_reminder_sent_at => 2.weeks.ago, :paid_special_offers => 1, :paid_special_offers_next_date_check => 6.months.from_now)
    
    expired_offers = Factory(:user, :email => "expired_offers@test.com", :paid_special_offers => 1, :paid_special_offers_next_date_check => 2.weeks.ago)
    
    has_changed_offer_recently = Factory(:user, :email => "has_changed_offer_recently@test.com", :paid_special_offers => 1, :paid_special_offers_next_date_check => 6.months.from_now)
    recent_so = Factory(:special_offer, :published_at => 2.weeks.ago, :author => has_changed_offer_recently)
    
    hasnt_changed_offer_recently = Factory(:user, :email => "hasnt_changed_offer_recently@test.com", :paid_special_offers => 1, :paid_special_offers_next_date_check => 6.months.from_now)
    old_so = Factory(:special_offer, :published_at => 6.weeks.ago, :author => hasnt_changed_offer_recently )
    ActionMailer::Base.deliveries = []
    
    TaskUtils.send_offers_reminder
    
    assert_equal 2, ActionMailer::Base.deliveries.size
    assert ActionMailer::Base.deliveries.map(&:to).flatten.include?(hasnt_created_offer.email)
    assert ActionMailer::Base.deliveries.map(&:to).flatten.include?(hasnt_changed_offer_recently.email)    
  end
  
  def test_send_offers_reminder_gv
    hasnt_created_offer = Factory(:user, :email => "hasnt_created_offer@test.com", :paid_gift_vouchers => 1, :paid_gift_vouchers_next_date_check => 6.months.from_now)
    
    expired_offers = Factory(:user, :email => "expired_offers@test.com", :paid_gift_vouchers => 1, :paid_gift_vouchers_next_date_check => 2.weeks.ago)
    
    has_changed_offer_recently = Factory(:user, :email => "has_changed_offer_recently@test.com", :paid_gift_vouchers => 1, :paid_gift_vouchers_next_date_check => 6.months.from_now)
    recent_gv = Factory(:gift_voucher, :published_at => 2.weeks.ago, :author => has_changed_offer_recently)
    
    hasnt_changed_offer_recently = Factory(:user, :email => "hasnt_changed_offer_recently@test.com", :paid_gift_vouchers => 1, :paid_gift_vouchers_next_date_check => 6.months.from_now)
    old_gv = Factory(:gift_voucher, :published_at => 6.weeks.ago, :author => hasnt_changed_offer_recently )
    ActionMailer::Base.deliveries = []
    
    TaskUtils.send_offers_reminder
    
    assert_equal 2, ActionMailer::Base.deliveries.size
    assert ActionMailer::Base.deliveries.map(&:to).flatten.include?(hasnt_created_offer.email)
    assert ActionMailer::Base.deliveries.map(&:to).flatten.include?(hasnt_changed_offer_recently.email)    
      
    ActionMailer::Base.deliveries = []
    TaskUtils.send_offers_reminder
    assert_equal 0, ActionMailer::Base.deliveries.size, "Reminders should only be sent once"
    
  end
  
  def test_generate_autocomplete_subcategories
    nz = countries(:nz)
    TaskUtils.delete_subcat_files
    old_lca = Subcategory.last_created_at
    TaskUtils.generate_autocomplete_subcategories
    ts = JsCounter.subcats_value(nz)
    sleep 1
    subcat = Factory(:subcategory)
    assert old_lca < Subcategory.last_created_at, "A new subcategory was created, the last_created_at should have changed"
    TaskUtils.generate_autocomplete_subcategories
    new_ts = JsCounter.subcats_value(nz)
    assert ts < new_ts, "A newer timestamp should have been creates, but ts is: #{ts} and new_ts is: #{new_ts}"
    TaskUtils.delete_subcat_files
  end
  
  def test_generate_autocomplete_subcategories_with_invalid_timestamp
    nz = countries(:nz)
    TaskUtils.delete_subcat_files
    invalid_timestamp = 1234352454
    JsCounter.set_subcats(nz, invalid_timestamp)
    TaskUtils.generate_autocomplete_subcategories
    ts = JsCounter.subcats_value(nz)
    assert_not_equal invalid_timestamp, ts
    assert File.exists?("#{RAILS_ROOT}/public/javascripts/subcategories-nz-#{ts}.js")
    assert !File.exists?("#{RAILS_ROOT}/public/javascripts/subcategories-nz-#{invalid_timestamp}.js")
    TaskUtils.delete_subcat_files
  end
  
  def test_generate_autocomplete_subcategories_with_existing_timestamp_but_no_file
    nz = countries(:nz)
    TaskUtils.delete_subcat_files
    invalid_timestamp = Subcategory.last_subcat_or_member_created_at(nz).to_i+1
    assert !File.exists?("#{RAILS_ROOT}/public/javascripts/subcategories-#{invalid_timestamp}.js")
    JsCounter.set_subcats(nz, invalid_timestamp)
    TaskUtils.generate_autocomplete_subcategories
    ts = JsCounter.subcats_value(nz)
    assert_not_equal invalid_timestamp, ts
    assert File.exists?("#{RAILS_ROOT}/public/javascripts/subcategories-nz-#{ts}.js")
    assert !File.exists?("#{RAILS_ROOT}/public/javascripts/subcategories-nz-#{invalid_timestamp}.js")
    TaskUtils.delete_subcat_files
  end
  
  def test_generate_autocomplete_subcategories_with_existing_timestamp_but_no_file2
    nz = countries(:nz)
    TaskUtils.delete_subcat_files
    invalid_timestamp = Subcategory.last_subcat_or_member_created_at(nz).to_i-1
    assert !File.exists?("#{RAILS_ROOT}/public/javascripts/subcategories-nz-#{invalid_timestamp}.js")
    JsCounter.set_subcats(nz, invalid_timestamp)
    TaskUtils.generate_autocomplete_subcategories
    ts = JsCounter.subcats_value(nz)
    assert_not_equal invalid_timestamp, ts
    assert File.exists?("#{RAILS_ROOT}/public/javascripts/subcategories-nz-#{ts}.js")
    assert !File.exists?("#{RAILS_ROOT}/public/javascripts/subcategories-nz-#{invalid_timestamp}.js")
    TaskUtils.delete_subcat_files
  end
  
  def test_generate_autocomplete_subcategories_with_existing_timestamp_but_no_file3
    nz = countries(:nz)
    TaskUtils.delete_subcat_files
    initial_timestamp = Subcategory.last_subcat_or_member_created_at(nz).to_i
    assert !File.exists?("#{RAILS_ROOT}/public/javascripts/subcategories-nz-#{initial_timestamp}.js")
    JsCounter.set_subcats(nz, initial_timestamp)
    TaskUtils.generate_autocomplete_subcategories
    ts = JsCounter.subcats_value(nz)
    assert_equal initial_timestamp, ts
    assert File.exists?("#{RAILS_ROOT}/public/javascripts/subcategories-nz-#{initial_timestamp}.js")
    TaskUtils.delete_subcat_files
  end
  
  def test_generate_autocomplete_subcategories_content
    fm = Factory(:role)
    nz = countries(:nz)
    user_with_quote = Factory(:user, :last_name => "O'Neil", :country => nz)
    user_with_quote.roles << fm
    profile = Factory(:user_profile, :user => user_with_quote )
    s = ""
    assert User.full_members.published.include?(user_with_quote)
    TaskUtils.generate_autocomplete_subcategories_content(s, nz)
    assert_match %r{O\\'Neil}, s, "Single quotes should be escaped"
  end

  def test_notify_unpublished_users
    unpublished_user = Factory(:user)
    unpublished_profile = Factory(:user_profile, :user => unpublished_user, :state => "draft")
    ActionMailer::Base.deliveries = []
    
    
    TaskUtils.notify_unpublished_users

    assert_equal 1, ActionMailer::Base.deliveries.size
        
    new_email = ActionMailer::Base.deliveries.first
    assert_equal [unpublished_user.email], new_email.to
  end

  def test_check_pending_payments
    pending_payment = Factory(:payment, :status => "pending")
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
    
    assert_equal 2, ActionMailer::Base.deliveries.size, "Should be 1 email to user with expired trial session + 1 alert to Megan"
    user_expired_special_offers.reload
    assert old_next_check < user_expired_special_offers.paid_special_offers_next_date_check, "The next date check should have moved forward, but old_next_check is #{old_next_check} and the new one is #{user_expired_special_offers.paid_special_offers_next_date_check}"
    assert_in_delta 6.months.from_now.to_time.to_f, user_expired_special_offers.paid_special_offers_next_date_check.to_time.to_f, 60*60*24*2, "More or less (two day leeway to account for leap years)"
    email = ActionMailer::Base.deliveries.last
    assert_not_nil email
    assert_match /Time to renew/, email.subject
    
    assert_equal 2, user_expired_special_offers.special_offers.published.size, "There should be only 2 published trial sessions left"
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
    
    assert_equal 2, ActionMailer::Base.deliveries.size, "Should be 1 email to user with expiring trial session + 1 alert to Megan"
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

  def test_check_feature_expiration_expired_highlighted_with_old_stored_token
    user_expired_photo = Factory(:user, :paid_highlighted => true, :paid_highlighted_until => 6.days.ago )
    token = Factory(:stored_token, :user => user_expired_photo, :created_at => 6.months.ago )
    assert user_expired_photo.paid_highlighted?
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    
    TaskUtils.check_feature_expiration
    
    assert_equal 0, ActionMailer::Base.deliveries.size, "Should be no email, as the user has an old stored token"    
  end

  def test_check_feature_expiration_expired_highlighted_with_recent_stored_token
    user_expired_photo = Factory(:user, :paid_highlighted => true, :paid_highlighted_until => 6.days.ago )
    token = Factory(:stored_token, :user => user_expired_photo, :created_at => 1.day.ago )
    assert user_expired_photo.paid_highlighted?
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    
    TaskUtils.check_feature_expiration
    
    assert_equal 2, ActionMailer::Base.deliveries.size, "Should be emails, because the stored token is more recent than the expiration of the paid feature"
  end

  def test_charge_expired_features_photo
    user = Factory(:user, :paid_photo => true, :paid_photo_until => 6.days.ago.to_date )
    old_paid_until = user.paid_photo_until
    order = Factory(:order, :photo => true, :user => user, :created_at => 1.year.ago-6.days )
    token = Factory(:stored_token, :user => user, :created_at => 6.months.ago )
    old_orders_size = user.orders.size
    assert user.paid_photo?
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    
    TaskUtils.charge_expired_features
    
    user.reload
    assert user.paid_photo_until > old_paid_until, "The photo feature should have been extended, but is: #{user.paid_photo_until}"
    assert_equal old_orders_size+1, user.orders.size
    order = user.orders.last
    assert_equal 2900, order.payment.amount
    assert_equal 1, ActionMailer::Base.deliveries.size, "Should be 1 email stating the charge"
    email = ActionMailer::Base.deliveries.first
    assert_equal "[Be Amazing(test)] Invoice for your auto-renewed features", email.subject
    
    ActionMailer::Base.deliveries = []
    TaskUtils.charge_expired_features
    user.reload
    assert_equal old_orders_size+1, user.orders.size, "The features should only be charged once"
    assert_equal 0, ActionMailer::Base.deliveries.size, "The email should only be sent once"    
  end

  def test_charge_expired_features_highlight
    user = Factory(:user, :paid_highlighted => true, :paid_highlighted_until => 6.days.ago.to_date )
    old_paid_until = user.paid_highlighted_until
    order = Factory(:order, :highlighted => true, :user => user, :created_at => 1.year.ago-6.days )
    token = Factory(:stored_token, :user => user, :created_at => 6.months.ago )
    old_orders_size = user.orders.size
    assert user.paid_highlighted?
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    
    TaskUtils.charge_expired_features
    
    user.reload
    assert user.paid_highlighted_until > old_paid_until, "The highlighted feature should have been extended, but is: #{user.paid_highlighted_until}"
    assert_equal old_orders_size+1, user.orders.size
    order = user.orders.last
    assert_equal 1000, order.payment.amount
    assert_equal 1, ActionMailer::Base.deliveries.size, "Should be 1 email stating the charge"
    email = ActionMailer::Base.deliveries.first
    assert_equal "[Be Amazing(test)] Invoice for your auto-renewed features", email.subject
    
    ActionMailer::Base.deliveries = []
    TaskUtils.charge_expired_features
    user.reload
    assert_equal old_orders_size+1, user.orders.size, "The features should only be charged once"
    assert_equal 0, ActionMailer::Base.deliveries.size, "The email should only be sent once"    
  end

  def test_charge_expired_features_so
    user = Factory(:user, :paid_special_offers => 3, :paid_special_offers_next_date_check => 6.days.ago.to_date )
    old_paid_check = user.paid_special_offers_next_date_check
    order = Factory(:order, :special_offers => 3, :user => user, :created_at => 1.year.ago-6.days )
    token = Factory(:stored_token, :user => user, :created_at => 6.months.ago )
    old_orders_size = user.orders.size
    assert user.has_paid_special_offers?
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    
    TaskUtils.charge_expired_features
    
    user.reload
    assert user.paid_special_offers_next_date_check > old_paid_check, "The SO feature should have been extended, but is: #{user.paid_special_offers_next_date_check}"
    assert_equal old_orders_size+1, user.orders.size
    order = user.orders.last
    assert_equal 2250, order.payment.amount
    assert_equal 1, ActionMailer::Base.deliveries.size, "Should be 1 email stating the charge"
    email = ActionMailer::Base.deliveries.first
    assert_equal "[Be Amazing(test)] Invoice for your auto-renewed features", email.subject
    
    ActionMailer::Base.deliveries = []
    TaskUtils.charge_expired_features
    user.reload
    assert_equal old_orders_size+1, user.orders.size, "The features should only be charged once"
    assert_equal 0, ActionMailer::Base.deliveries.size, "The email should only be sent once"    
  end

  def test_charge_expired_features_whole_package
    user = Factory(:user, :paid_special_offers => 1, :paid_special_offers_next_date_check => 6.days.ago.to_date,
    :paid_gift_vouchers => 1, :paid_gift_vouchers_next_date_check => 6.days.ago.to_date, :paid_photo => true,
    :paid_photo_until => 6.days.ago.to_date, :paid_highlighted => true, :paid_highlighted_until => 6.days.ago.to_date )
    old_paid_so_check = user.paid_special_offers_next_date_check
    order = Factory(:order, :special_offers => 1, :gift_vouchers => 1, :photo => true, :highlighted => true,
    :whole_package => true, :user => user, :created_at => 1.year.ago-6.days, :state => "paid" )
    token = Factory(:stored_token, :user => user, :created_at => 6.months.ago )
    old_orders_size = user.orders.size
    assert user.has_paid_special_offers?
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    
    TaskUtils.charge_expired_features
    
    user.reload
    assert user.paid_special_offers_next_date_check > old_paid_so_check, "The SO feature should have been extended, but is: #{user.paid_special_offers_next_date_check}"
    assert_equal old_orders_size+1, user.orders.size
    order = user.orders.last
    assert_equal 5400, order.payment.amount
    assert_equal 1, ActionMailer::Base.deliveries.size, "Should be 1 email stating the charge"
    email = ActionMailer::Base.deliveries.first
    assert_equal "[Be Amazing(test)] Invoice for your auto-renewed features", email.subject
    
    ActionMailer::Base.deliveries = []
    TaskUtils.charge_expired_features
    user.reload
    assert_equal old_orders_size+1, user.orders.size, "The features should only be charged once"
    assert_equal 0, ActionMailer::Base.deliveries.size, "The email should only be sent once"    
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

  def test_check_feature_expiration_expiring_highlighted_with_active_stored_token
    user = Factory(:user, :paid_highlighted => true, :paid_highlighted_until => 6.days.from_now )
    old_size = user.orders.size
    token = Factory(:stored_token, :user => user )
    assert user.has_current_stored_tokens?
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    
    TaskUtils.check_feature_expiration
    
    user.reload
    assert_equal old_size, user.orders.size, "No order should have been created: this is only a warning"
    assert_equal 1, ActionMailer::Base.deliveries.size, "Should be 1 email to user saying that we will charge stored card"
    email = ActionMailer::Base.deliveries.first
    assert_not_nil email
    assert_equal "[Be Amazing(test)] Your features will be automatically renewed", email.subject
    assert_match /\$10\.00/, email.body
    
    ActionMailer::Base.deliveries = []
    TaskUtils.check_feature_expiration
    assert_equal 0, ActionMailer::Base.deliveries.size, "The email should only be sent once"    
  end

  def test_rotate_users
    user1 = Factory(:user, :paid_photo => true, :membership_type => "full_member")
    user1.user_profile.update_attribute(:state, "published")
    user2 = Factory(:user, :paid_photo => true, :membership_type => "full_member")
    user2.user_profile.update_attribute(:state, "published")
    assert !user2.free_listing?
    cyrille = users(:cyrille)
    old_updated_at = cyrille.updated_at
    norma = users(:norma)
    norma.paid_photo = true
    norma.paid_highlighted = true
    norma.save!
    norma.reload
    TaskUtils.rotate_users
    featured_users = User.homepage_featured_users
    assert_equal User::DAILY_USER_ROTATION, featured_users.size

    TaskUtils.rotate_users
    new_featured_users = User.homepage_featured_users
    assert_equal 1, new_featured_users.size
    assert featured_users != new_featured_users
    
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
    ActionMailer::Base.deliveries = []
    
    TaskUtils.send_reminder_on_expiring_memberships

    assert_equal 2, ActionMailer::Base.deliveries.size
    
    #on 2nd run there should be no emails sent
    ActionMailer::Base.deliveries = []

    TaskUtils.send_reminder_on_expiring_memberships

    assert_equal 0, ActionMailer::Base.deliveries.size
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
		nz = countries(:nz)
		
		TaskUtils.count_users
		
		pract_nz = CategoriesCountry.find_by_category_id_and_country_id(practitioners.id, nz.id)
		assert_not_nil pract_nz
		assert_equal 8, pract_nz.count

		hypno_nz = SubcategoriesCountry.find_by_subcategory_id_and_country_id(hypnotherapy.id, nz.id)
		assert_not_nil hypno_nz
		assert_equal 5, hypno_nz.count
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
      nz = countries(:nz)
      canterbury_christchurch_city = districts(:canterbury_christchurch_city)
      hypnotherapy = subcategories(:hypnotherapy)
      results = User.search_results(nz.id, nil, hypnotherapy.id, canterbury.id, nil, 1)
  #     puts "============= results:"
  #     results.each do |r|
  #       puts "#{r.name}  - #{r.free_listing}- #{r.id}"
  #       r.subcategories_users.each do |su|
  #         puts "+++++++++ #{su.subcategory_id} - #{su.position}"
  #       end
  #     end

      TaskUtils.rotate_user_positions_in_subcategories
      new_results = User.search_results(nz.id, nil, hypnotherapy.id, canterbury.id, nil, 1)
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
      user = User.new(:country => countries(:nz), :first_name => "Joe", :last_name => "Test", :district_id => canterbury_christchurch_city.id,
        :region_id => canterbury.id, :email => "joe@test.com",
        :membership_type => "full_member", :professional => true, :subcategory1_id => hypnotherapy.id,
        :password => "blablabla", :password_confirmation => "blablabla", :accept_terms => true )
      user.save!
      user.confirm!

      user.subcategories_users.reload
      assert_equal 1, user.subcategories_users.size
      assert_equal old_user_size+1, User.all.size
      after_insert_results = User.search_results(nz.id, nil, hypnotherapy.id, canterbury.id, nil, 1)
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
      nz = countries(:nz)
      canterbury_christchurch_city = districts(:canterbury_christchurch_city)
      practitioners = categories(:practitioners)
      results = User.search_results(nz.id, practitioners.id, nil, canterbury.id, nil, 1)
  #     puts "============= results:"
  #     results.each do |r|
  #       puts "#{r.name}  - #{r.free_listing}- #{r.id}"
  #       r.subcategories_users.each do |su|
  #         puts "+++++++++ #{su.subcategory_id} - #{su.position}"
  #       end
  #     end

      TaskUtils.rotate_user_positions_in_categories
      new_results = User.search_results(nz.id, practitioners.id, nil, canterbury.id, nil, 1)
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
      user = User.new(:country => countries(:nz), :first_name => "Joe", :last_name => "Test", :district_id => canterbury_christchurch_city.id,
        :region_id => canterbury.id, :email => "joe@test.com",
        :membership_type => "full_member", :professional => true, :subcategory1_id => subcategories(:hypnotherapy).id,
        :password => "blablabla", :password_confirmation => "blablabla", :accept_terms => true )
      user.save!
      user.confirm!

      user.categories_users.reload
      assert_equal 1, user.categories_users.size
      assert_equal old_user_size+1, User.all.size
      after_insert_results = User.search_results(nz.id, practitioners.id, nil, canterbury.id, nil, 1)
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
