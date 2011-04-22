require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase

	fixtures :all

  def test_resident_expert_in_subcat
    subcat = Factory(:subcategory)
    user = Factory(:user, :subcategory1_id => subcat.id)
    assert !user.resident_expert_in_subcat?(subcat)
    
    article = Factory(:article, :author => user, :subcategory1_id => subcat.id, :state => "draft")
    article.publish!
    
    user.reload
    
    assert user.resident_expert_in_subcat?(subcat)
  end
  
  def test_had_whole_package_order_1_year_ago
    user = Factory(:user, :paid_special_offers => 1, :paid_special_offers_next_date_check => 6.days.ago.to_date,
    :paid_gift_vouchers => 1, :paid_gift_vouchers_next_date_check => 6.days.ago.to_date, :paid_photo => true,
    :paid_photo_until => 6.days.ago.to_date, :paid_highlighted => true, :paid_highlighted_until => 6.days.ago.to_date )
    order = Factory(:order, :special_offers => 3, :user => user, :created_at => 1.year.ago-6.days, :state => "paid" )
    user.reload
    assert !user.had_whole_package_order_1_year_ago?(6.days.ago)
    order2 = Factory(:order, :special_offers => 1, :gift_vouchers => 1, :photo => true, :highlighted => true,
    :whole_package => true, :user => user, :created_at => 1.year.ago-6.days, :state => "paid" )
    user.reload
    assert user.had_whole_package_order_1_year_ago?(6.days.ago)
  end

  def test_remove_auto_renewable_features_old_stored_token
    user = Factory(:user, :paid_photo => true, :paid_photo_until => 6.days.ago )
    token = Factory(:stored_token, :user => user, :created_at => 8.days.ago )
    
    res = user.remove_auto_renewable_features(["photo"])
    assert res.blank?, "There should be no features left, as they will be auto-renewed"
  end

  def test_remove_auto_renewable_features_recent_stored_token
    user = Factory(:user, :paid_photo => true, :paid_photo_until => 6.days.ago )
    token = Factory(:stored_token, :user => user, :created_at => 1.day.ago )
    
    res = user.remove_auto_renewable_features(["photo"])
    assert !res.blank?, "The stored token was created more recently than the expiration of the card"
  end

  def test_resident_expert2
    subcat = Factory(:subcategory, :name => "Cyrille test subcat")
    user = Factory(:user, :subcategory1_id => subcat.id)
    article1 = Factory(:article, :author => user, :subcategory1_id => subcat.id, :state => "draft")
    article1.publish!
    TaskUtils.recompute_resident_experts
    user.reload
    assert user.resident_expert?
  end
  
  def test_points_in_subcategory
    subcat = Factory(:subcategory)
    user = Factory(:user, :subcategory1_id => subcat.id)
    article = Factory(:article, :author => user, :subcategory1_id => subcat.id, :state => "draft" )
    article.publish!
    assert user.points_in_subcategory(subcat.id) > 0
  end
  
  def test_hasnt_changed_special_offers_recently
    has_changed_offer_recently = Factory(:user, :email => "has_changed_offer_recently@test.com", :paid_special_offers => 1, :paid_special_offers_next_date_check => 6.months.from_now)
    recent_so = Factory(:special_offer, :published_at => 2.weeks.ago, :author => has_changed_offer_recently)
    
    hasnt_changed_offer_recently = Factory(:user, :email => "hasnt_changed_offer_recently@test.com", :paid_special_offers => 1, :paid_special_offers_next_date_check => 6.months.from_now)
    old_so = Factory(:special_offer, :published_at => 6.weeks.ago, :author => hasnt_changed_offer_recently )
    
    assert hasnt_changed_offer_recently.hasnt_changed_special_offers_recently?
    assert !has_changed_offer_recently.hasnt_changed_special_offers_recently?
  end

  def test_compute_points
    user = Factory(:user)
    sub1 = Factory(:subcategory)
    sub2 = Factory(:subcategory)
    article1 = Factory(:article, :author => user, :published_at => 2.days.ago)
    Factory(:articles_subcategory, :article_id => article1.id, :subcategory_id => sub1.id)  
    article2 = Factory(:article, :author => user, :published_at => 32.days.ago)
    Factory(:articles_subcategory, :article_id => article2.id, :subcategory_id => sub1.id)  
    article3 = Factory(:article, :author => user, :published_at => 2.days.ago, :state => "draft")
    Factory(:articles_subcategory, :article_id => article3.id, :subcategory_id => sub1.id)  
    article4 = Factory(:article, :author => user, :published_at => 2.days.ago)
    Factory(:articles_subcategory, :article_id => article4.id, :subcategory_id => sub2.id)  
    assert_equal 15, user.compute_points(sub1)
  end

  def test_resident_expert
    nz = countries(:nz)
    sub1 = Factory(:subcategory)
    sub2 = Factory(:subcategory)
    user = Factory(:user, :subcategory1_id  => sub1.id)
    assert user.active?
    article1 = Factory(:article, :author => user, :published_at => 2.days.ago)
    Factory(:articles_subcategory, :article_id => article1.id, :subcategory_id => sub1.id)  
    article2 = Factory(:article, :author => user, :published_at => 32.days.ago)
    Factory(:articles_subcategory, :article_id => article2.id, :subcategory_id => sub1.id)  
    article3 = Factory(:article, :author => user, :published_at => 2.days.ago)
    Factory(:articles_subcategory, :article_id => article3.id, :subcategory_id => sub2.id)  
    article4 = Factory(:article, :author => user, :published_at => 2.days.ago)
    Factory(:articles_subcategory, :article_id => article4.id, :subcategory_id => sub2.id)  
    TaskUtils.recompute_points
    TaskUtils.recompute_resident_experts
    user.reload
    experts = User.resident_experts(nz)
    assert experts.include?(user)
    assert_equal "#{sub1.name}", user.resident_expertise_description, "Subcategory2 should not be included, because it is not in the listed subcategories of user"
  end

  def test_notify_unpublished
    user_yep = Factory(:user, :notify_unpublished => true)
    user_no = Factory(:user, :notify_unpublished => false)
    assert User.notify_unpublished.include?(user_yep)
    assert !User.notify_unpublished.include?(user_no)
  end

  def test_unpublished
    user_unpublished = Factory(:user)
    user_unpublished_profile = Factory(:user_profile, :user => user_unpublished, :state => "draft" )
    user_unpublished.user_profile = user_unpublished_profile
    user_unpublished.save
    user_published = Factory(:user)
    user_published_profile = Factory(:user_profile, :user => user_published, :state => "published" )
    user_published.user_profile = user_published_profile
    user_published.save
    assert User.unpublished.include?(user_unpublished)
    assert !User.unpublished.include?(user_published)
  end

  def test_had_visits_since
    sub = Factory(:subcategory)
    user = Factory(:user, :subcategory1_id => sub.id)
    user_event = Factory(:user_event, :event_type => UserEvent::VISIT_SUBCATEGORY, :subcategory_id => sub.id, :logged_at => 3.days.ago)
    assert user.had_visits_since?(7.days.ago)
    assert !user.had_visits_since?(2.days.ago)
  end

  def test_count_visits_since
    sub = Factory(:subcategory)
    sub2 = Factory(:subcategory)
    user = Factory(:user, :subcategory1_id => sub.id, :subcategory2_id => sub2.id)
    user_event = Factory(:user_event, :event_type => UserEvent::VISIT_SUBCATEGORY, :subcategory_id => sub.id, :logged_at => 3.days.ago)
    user_event2 = Factory(:user_event, :event_type => UserEvent::VISIT_SUBCATEGORY, :subcategory_id => sub2.id, :logged_at => 3.days.ago)
    user_event3 = Factory(:user_event, :event_type => UserEvent::VISIT_SUBCATEGORY, :subcategory_id => sub2.id, :logged_at => 3.days.ago)
    assert_equal 3, user.count_visits_since(7.days.ago)
  end

  def test_visits_since
    sub = Factory(:subcategory)
    sub2 = Factory(:subcategory)
    
    user = Factory(:user, :subcategory1_id => sub.id, :subcategory2_id => sub2.id)
    user_event = Factory(:user_event, :event_type => UserEvent::VISIT_SUBCATEGORY, :subcategory_id => sub.id, :logged_at => 3.days.ago)
    user_event2 = Factory(:user_event, :event_type => UserEvent::VISIT_SUBCATEGORY, :subcategory_id => sub.id, :logged_at => 3.days.ago)
    user_event3 = Factory(:user_event, :event_type => UserEvent::VISIT_SUBCATEGORY, :subcategory_id => sub2.id, :logged_at => 3.days.ago)
    hash = user.visits_since(7.days.ago)
    assert hash.keys.include?(sub.name)
    assert hash.keys.include?(sub2.name)
    assert_equal 2, hash[sub.name]
    assert_equal 1, hash[sub2.name]
  end

  def test_currently_selected_and_last_10_published
    newsletter = Factory(:newsletter)
    user = Factory(:user)
    user_profile = Factory(:user_profile, :user => user, :state => "published", :published_at => Time.now)
    
    newsletter.users << user
    
    my_users = User.currently_selected_and_last_10_published(newsletter)
    
    assert_equal 1, my_users.select{|my_user| my_user == user}.size, "New user #{user.name} doesn't appear once: #{my_users.map(&:name).to_sentence}"
  end
  
  def test_get_emails_from_string
    emails = User.get_emails_from_string("joe@test.com jane@yahoo.fr bob@gmail.com")
    assert_equal ["joe@test.com", "jane@yahoo.fr", "bob@gmail.com"], emails
    
    emails = User.get_emails_from_string("joe@test.com, jane@yahoo.fr,bob@gmail.com")
    assert_equal ["joe@test.com", "jane@yahoo.fr", "bob@gmail.com"], emails
    
    emails = User.get_emails_from_string("joe jane@yahoo.fr bob@gmail.com")
    assert_equal ["jane@yahoo.fr", "bob@gmail.com"], emails
    
    emails = User.get_emails_from_string("joe @yahoo.fr bWHATl.com")
    assert_equal [], emails
  end
  
  def test_remove_subcats
    cyrille = users(:cyrille)
    old_subcats = Subcategory.all.map(&:name)
    old_size = old_subcats.size
    new_subcats = cyrille.remove_subcats(old_subcats)
    assert_equal old_size-1, new_subcats.size
  end

  def test_same_subcategories
    cyrille = users(:cyrille)
    old_size = cyrille.subcategories.size
    cyrille.subcategory2_id = subcategories(:yoga).id
    cyrille.subcategory3_id = subcategories(:yoga).id
    cyrille.save!
    cyrille.reload
    assert_nil cyrille.subcategories[2], "Yoga should have been saved only once"
  end


  def test_generate_random_password
    rp = User.generate_random_password
    assert_not_nil rp
  end

  def test_renew_token
    norma = users(:norma)
    old_token = norma.unsubscribe_token
    norma.renew_token
    norma.reload
    assert_not_equal old_token, norma.unsubscribe_token, "Token should have been renewed"
  end

  def test_roles_description
    assert_equal "Admin, Full member", users(:cyrille).roles_description
  end

  def test_location
    resident_expert_user = users(:resident_expert_user)
    assert_equal "Wellington City, Wellington Region", resident_expert_user.location
  end
    
  def test_destroy
    cyrille = users(:cyrille)
    old_email = cyrille.email
    cyrille.destroy
    assert_nil User.find_by_email(old_email)
  end

  def test_expertises
    norma = users(:norma)
    aromatherapy = subcategories(:aromatherapy)
    hypnotherapy = subcategories(:hypnotherapy)
    assert_equal hypnotherapy.name, norma.key_expertise_name
    assert_equal aromatherapy.name, norma.key_expertise_name(aromatherapy)
    assert_equal [aromatherapy.name], norma.other_expertise_names
    assert_equal [hypnotherapy.name], norma.other_expertise_names(aromatherapy)    
  end

  def test_find_paying_member_by_name
    cyrille = users(:cyrille)
    assert_equal cyrille, User.find_paying_member_by_name(cyrille.full_name)
    assert_equal nil, User.find_paying_member_by_name("Bla blabla")
  end
  
  def test_find_paying_member_by_name_with_middle_names
    norma = users(:norma)
    assert_equal norma, User.find_paying_member_by_name(norma.full_name)
  end

  def test_find_paying_member_by_name_with_no_business_name
    user = Factory(:user, :business_name => nil )
    assert !user.free_listing?
    assert_equal user, User.find_paying_member_by_name(user.full_name)
  end
  
  def test_published
    assert_equal User.full_members.active.published.size, User.full_members.select{|fm| !fm.user_profile.nil? && fm.user_profile.published? && fm.active?}.size
  end

  def test_find_article
    cyrille = users(:cyrille)
    rmoore = users(:rmoore)
    norma = users(:norma)
    jogging = articles(:jogging)
    
    #cyrille is admin
    assert_equal jogging, cyrille.find_article(jogging.id)
    #rmoore is the author
    assert_equal jogging, rmoore.find_article(jogging.id)
    #norma shouldn't be able to access the article
    assert_raise ActiveRecord::RecordNotFound do
      norma.find_article(jogging.id)
    end
  end
  
  def test_launch_date
    norma = users(:norma)
    norma.member_since = Time.parse("Jun 1 2008")
    norma.save!
    assert !norma.member_since_launch_date?
    
    norma.member_since = Time.parse("Jul 2 2009")
    norma.save!
    assert norma.member_since_launch_date?    
  end

  def test_paying
    assert User.paying.size > 2
  end

  def test_clean_website
    assert_equal "http://www.google.com", users(:norma).clean_website
    assert_equal "http://www.google.com", users(:cyrille).clean_website
  end
  

  def test_find_article_for_user
    jogging_draft = articles(:jogging_draft)
    yoga = articles(:yoga)
    cyrille = users(:cyrille)
    rmoore = users(:rmoore)
    norma = users(:norma)
    assert_equal yoga, cyrille.find_article_for_user(yoga.slug, cyrille)
    assert_nil cyrille.find_article_for_user(yoga.slug, norma)
    assert_nil cyrille.find_article_for_user(yoga.slug, nil)

    #Roger Moore is the other
    assert_equal jogging_draft, rmoore.find_article_for_user(jogging_draft.slug, rmoore)
    
    #but Cyrille is admin so he can see Roger Moore's draft articles
    assert_equal jogging_draft, rmoore.find_article_for_user(jogging_draft.slug, cyrille)

    assert_nil rmoore.find_article_for_user(jogging_draft.slug, norma)
    assert_nil rmoore.find_article_for_user(jogging_draft.slug, nil)
  end

  def test_find_how_to_for_user
    money = how_tos(:money)
    improve = how_tos(:improve)
    cyrille = users(:cyrille)
    norma = users(:norma)
    rmoore = users(:rmoore)
    assert_equal improve, cyrille.find_how_to_for_user(improve.slug, cyrille)
    assert_nil cyrille.find_how_to_for_user(improve.slug, norma)
    assert_nil rmoore.find_how_to_for_user(improve.slug, norma)
    assert_nil rmoore.find_how_to_for_user(improve.slug, nil)

    assert_equal money, cyrille.find_how_to_for_user(money.slug, cyrille)
    assert_equal money, cyrille.find_how_to_for_user(money.slug, norma)
    assert_equal money, cyrille.find_how_to_for_user(money.slug, nil)
  end

  def test_find_special_offer_for_user
    one = special_offers(:one)
    free_trial = special_offers(:free_trial)
    cyrille = users(:cyrille)
    rmoore = users(:rmoore)
    norma = users(:norma)
    assert_equal one, cyrille.find_special_offer_for_user(one.slug, cyrille)
    assert_nil rmoore.find_special_offer_for_user(one.slug, norma)
    assert_nil rmoore.find_special_offer_for_user(one.slug, nil)

    assert_equal free_trial, cyrille.find_special_offer_for_user(free_trial.slug, cyrille)
    assert_equal free_trial, cyrille.find_special_offer_for_user(free_trial.slug, norma)
    assert_equal free_trial, cyrille.find_special_offer_for_user(free_trial.slug, nil)
  end

  def test_find_gift_voucher_for_user
    free_massage = gift_vouchers(:free_massage)
    free_massage_draft = gift_vouchers(:free_massage_draft)
    cyrille = users(:cyrille)
    norma = users(:norma)
    rmoore = users(:rmoore)
    assert_equal free_massage_draft, cyrille.find_gift_voucher_for_user(free_massage_draft.slug, cyrille)
    assert_nil rmoore.find_gift_voucher_for_user(free_massage_draft.slug, norma)
    assert_nil rmoore.find_gift_voucher_for_user(free_massage_draft.slug, nil)

    assert_equal free_massage, cyrille.find_gift_voucher_for_user(free_massage.slug, cyrille)
    assert_equal free_massage, cyrille.find_gift_voucher_for_user(free_massage.slug, norma)
    assert_equal free_massage, cyrille.find_gift_voucher_for_user(free_massage.slug, nil)
  end
  
  def test_gift_vouchers_size
    assert_equal 2, users(:norma).gift_vouchers.size
    assert_equal 2, users(:cyrille).gift_vouchers.size
  end

  def test_special_offers_size
    cyrille = users(:cyrille)
    assert_equal 2, cyrille.special_offers.size
  end

  def test_articles_size
    cyrille = users(:cyrille)
    assert_equal 2, cyrille.articles.size
    #counts both articles and 'how to' articles
    assert_equal 4, cyrille.articles_count_for_user(cyrille)
  end

  def test_events_for_week_around_date
    user = Factory(:user)
    ev = Factory(:user_event, :visited_user => user, :event_type => UserEvent::VISIT_PROFILE, :logged_at => Time.now )
    assert_equal 1, user.visited_user_events.for_week_around_date(Time.now).size
    assert_equal 0, user.visited_user_events.for_week_around_date(2.weeks.ago).size
  end

  def test_last_30days_redirect_website
    cyrille = users(:cyrille)
    assert_equal 1, cyrille.visited_user_events.redirect_website.last_30_days.size
  end

  def test_last_12months_redirect_website
    cyrille = users(:cyrille)
    assert_equal 2, cyrille.visited_user_events.redirect_website.last_12_months.size
  end

  def test_last_30days_received_messages
    cyrille = users(:cyrille)
    assert_equal 1, cyrille.visited_user_events.received_message.last_30_days.size
  end

  def test_last_12months_received_messages
    cyrille = users(:cyrille)
    assert_equal 2, cyrille.visited_user_events.received_message.last_12_months.size
  end

  def test_last_30days_profile_visits
    cyrille = users(:cyrille)
    assert_equal 1, cyrille.visited_user_events.visited_profile.last_30_days.size
  end

  def test_last_12_months_profile_visits
    cyrille = users(:cyrille)
    assert_equal 2, cyrille.visited_user_events.visited_profile.last_12_months.excludes_own.size
  end

  def test_invoices
    assert_equal 1, users(:cyrille).invoices.size
  end

  def test_role_description
    assert_equal "", users(:sgardiner).role_description
  end

  def test_css_class_role_description
    #if you change any below, make sure that the name is changed in the CSS
    assert_equal "title-user-free-listing", users(:rmoore).css_class_role_description
    assert_equal "title-user-paying", users(:sgardiner).css_class_role_description
  end

  def test_contact_details
    assert_equal "(06)3086130", users(:cyrille).contact_details
    assert_equal "23 Queen St<br/>One tree Hill<br/>03 333 44444<br/>021 567 234", users(:amcloughlin).contact_details
  end

  def test_reviewers
    reviewers = []
    #build the list the slow way (with lots of users, it would very slow)
    User.all.each do |u|
      reviewers << u if u.reviewer?
    end
    #now make sure that the named_scope finds the same result
    assert_equal reviewers.size, User.reviewers.size
  end

  def test_full_members
    full_members = []
    #build the list the slow way (with lots of users, it would very slow)
    User.all.each do |u|
      full_members << u if u.full_member?
    end
    #now make sure that the named_scope finds the same result
    assert_equal full_members.size, User.full_members.size
  end

  def test_location_change_on_update
    norma = users(:norma)
    old_latitude = norma.latitude
    old_longitude = norma.longitude
    norma.district_id = districts(:wellington_wellington_city).id
    norma.save
    norma.reload
    #latitude and longitude should have changed
    assert old_latitude != norma.latitude
    assert old_longitude != norma.longitude
  end

  def test_slug_on_update
    cyrille = users(:cyrille)
    cyrille.update_attributes(:last_name => "Jones")
    cyrille.reload
    assert_equal "cyrille-jones-bioboy-inc", cyrille.slug
  end

  def test_full_info
    assert_not_nil users(:cyrille).full_info
  end

  def test_default_how_to_book
    cyrille = users(:cyrille)
    assert_equal "Bookings can be made by phone or email:<br/>(06)3086130<br/>cbonnet99@yahoo.fr", cyrille.default_how_to_book
  end
  
  def test_validate
    user = User.new(:professional => true, :subcategory1_id => ""  )
    assert !user.valid?
    assert !user.errors[:district].blank?
    assert !user.errors[:subcategory1_id].blank?
  end
  
  def test_user_slug
    cyrille = users(:cyrille)
    assert_equal "cyrille-bonnet-bioboy-inc", cyrille.slug
  end

  def test_user_identical_slug
    cyrille = users(:cyrille)
    assert_raise ActiveRecord::RecordInvalid do
      new_user = Factory(:user, :first_name => cyrille.first_name, :last_name => cyrille.last_name, :business_name => cyrille.business_name)
    end
  end

  def test_articles
    cyrille = users(:cyrille)
    articles = cyrille.articles
    assert !articles.blank?
  end

  def test_count_newest_full_members
    assert_equal 2, User.count_newest_full_members
  end

  def test_sentence_to_review
    cyrille = users(:cyrille)
    assert_equal "7 items to review", cyrille.sentence_to_review
  end

  def test_roles
    canterbury_christchurch_city = districts(:canterbury_christchurch_city)
    canterbury = regions(:canterbury)
    hypnotherapy = subcategories(:hypnotherapy)
    old_roles_user_size = RolesUser.all.size
    user = User.new(:country => countries(:nz), :first_name => "Joe", :last_name => "Test", :district_id => canterbury_christchurch_city.id,
      :region_id => canterbury.id, :email => "joe@test.com",
      :membership_type => "full_member", :professional => true, :subcategory1_id => hypnotherapy.id,
      :password => "blablabla", :password_confirmation => "blablabla", :accept_terms => true  )
      user.save!

      assert_equal 1, user.roles.find_all_by_name("full_member").size
      assert_equal old_roles_user_size+1, RolesUser.all.size
  end
    
  def test_unique_tab_title
    cyrille = users(:cyrille)
    yoga = subcategories(:yoga)
    old_size = Tab.all.size
    cyrille.add_tab(yoga)
    assert_equal old_size+1, Tab.all.size
    cyrille.add_tab(yoga)
    #no new tab created: the title of the 2nd tab is not unique
    assert_equal old_size+1, Tab.all.size
  end

  def test_change_membership
    canterbury_christchurch_city = districts(:canterbury_christchurch_city)
    canterbury = regions(:canterbury)
    hypnotherapy = subcategories(:hypnotherapy)
    user = User.new(:country => countries(:nz), :first_name => "Joe", :last_name => "Test",
      :district_id => canterbury_christchurch_city.id, :business_name => "uytut",
      :region_id => canterbury.id, :email => "joe.bill@nunu.com",
      :free_listing => true, :professional => true,
      :password => "blablabla", :password_confirmation => "blablabla", :subcategory1_id => hypnotherapy.id )

    user.save!

    assert_equal 1, user.tabs.size
    user.membership_type = "full_member"
    user.save!
    user.reload
    assert_equal 1, user.tabs.size
    assert_equal "Hypnotherapy", user.tabs.first.title
    assert user.tabs.first.content.size > 30, "Tab content should be long (as we now have a default content), but content is only: #{user.tabs.first.content}"
    user.update_attributes(:last_name => "Test2")
    user.reload
    assert_equal 1, user.tabs.size
  end

  def test_phone_suffix
    cyrille = users(:cyrille)
    norma = users(:norma)
    assert_equal "3086130", cyrille.phone_suffix
    assert_equal "", norma.phone_suffix
  end

  def test_phone_prefix
    cyrille = users(:cyrille)
    norma = users(:norma)
    assert_equal "06", cyrille.phone_prefix
    assert_equal "06", norma.phone_prefix
  end

	def test_all_find_by_region_and_subcategories
		canterbury = regions(:canterbury)
		yoga = subcategories(:yoga)
		hypnotherapy = subcategories(:hypnotherapy)
		res = User.find_all_by_region_and_subcategories(canterbury, hypnotherapy)
		assert_equal 4, res.size
		res = User.find_all_by_region_and_subcategories(canterbury, hypnotherapy, yoga)
		assert_equal 5, res.size
	end

	def test_all_find_by_subcategories
		yoga = subcategories(:yoga)
		hypnotherapy = subcategories(:hypnotherapy)
		res = User.find_all_by_subcategories(hypnotherapy)
		assert_equal 5, res.size
		res = User.find_all_by_subcategories(hypnotherapy, yoga)
		assert_equal 6, res.size
	end

	def test_count_all_by_subcategories
		yoga = subcategories(:yoga)
		hypnotherapy = subcategories(:hypnotherapy)
		res = User.count_all_by_subcategories(hypnotherapy)
		assert_equal 5, res
		res = User.count_all_by_subcategories(hypnotherapy, yoga)
		assert_equal 6, res
	end

	def test_has_role
		sgardiner = users(:sgardiner)
		assert sgardiner.has_role?('full_member')
	end

	def test_search_results
		practitioners = categories(:practitioners)
		hypnotherapy = subcategories(:hypnotherapy)
		canterbury_christchurch_city = districts(:canterbury_christchurch_city)
    results = User.search_results(practitioners.id, hypnotherapy.id, nil, canterbury_christchurch_city.id, 1)
		assert_equal 3, results.size
	end

	def test_search_results_category_with_district
		practitioners = categories(:practitioners)
		canterbury_christchurch_city = districts(:canterbury_christchurch_city)
    results = User.search_results(practitioners.id, nil, nil, canterbury_christchurch_city.id, 1)
   # puts "========= results:"
   # results.each do |r|
   #   puts r.name
   # end
		assert_equal 3, results.size
	end
	
	def test_search_results_subcategory
		hypnotherapy = subcategories(:hypnotherapy)
    results = User.search_results(nil, hypnotherapy.id, nil, nil, 1)
		assert_equal 5, results.size
	end

    	def test_search_results_category_coaching
        coaches = categories(:coaches)
        results = User.search_results(coaches.id, nil, nil, nil, 1)
       # puts "========= results:"
       # results.each do |r|
       #   puts r.name
       # end
    		assert_equal 1, results.size
    	end

	def test_search_results_category_region
		practitioners = categories(:practitioners)
		canterbury = regions(:canterbury)
		assert_equal 4, User.search_results(practitioners.id, nil, canterbury.id, nil, 1).size
	end

	def test_subs
		rmoore = users(:rmoore)
		hypnotherapy = subcategories(:hypnotherapy)
		yoga = subcategories(:yoga)
    practitioners = categories(:practitioners)
		assert_equal [hypnotherapy, yoga], rmoore.subcategories
		test_user = User.find_by_email(rmoore.email)
		assert_equal [hypnotherapy, yoga], test_user.subcategories
    assert_equal [practitioners], test_user.categories
	end

	def test_create_without_subcategories
		wellington = regions(:wellington)
		wellington_wellington_city = districts(:wellington_wellington_city)

		new_user = User.new(:country => countries(:nz), :accept_terms => "1", :first_name => "Joe", :last_name => "Test", :business_name => "Test",
			:address1 => "1, Main St", :suburb => "Newtown", :district_id => wellington_wellington_city.id,
			:region_id => wellington.id, :phone => "04-28392173", :mobile => "", :email => "joe@test.com",
			:password => "blablabla", :password_confirmation => "blablabla", :professional => true  )
    assert !new_user.valid?
    assert_equal 1, new_user.errors.size
    assert_equal "^You must select your main expertise", new_user.errors[:subcategory1_id]
  end
	def test_create
		wellington = regions(:wellington)
		wellington_wellington_city = districts(:wellington_wellington_city)
		hypnotherapy = subcategories(:hypnotherapy)
		yoga = subcategories(:yoga)

		old_count = User.count
		new_user = User.new(:country => countries(:nz), :first_name => "Joe", :last_name => "Test", :business_name => "   Test",
			:address1 => "1, Main St", :suburb => "Newtown", :district_id => wellington_wellington_city.id,
			:region_id => wellington.id, :phone => "04-28392173", :mobile => "", :email => "joe@test.com",
			:subcategory1_id => hypnotherapy.id, :subcategory2_id => yoga.id, :subcategory3_id => nil, :accept_terms => true, 
			:password => "blablabla", :password_confirmation => "blablabla"  )
		
		new_user.save!
		
		assert !new_user.confirmation_token.blank?
		assert !new_user.active?
		
		assert_equal old_count+1, User.count
		assert_equal [hypnotherapy, yoga], new_user.subcategories
		new_user2 = User.find_by_email("joe@test.com")
		assert_equal [hypnotherapy, yoga], new_user2.subcategories
    assert_not_nil new_user.user_profile
    assert_not_nil new_user.latitude
    assert_not_nil new_user.longitude
	end
end