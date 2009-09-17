require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase

	fixtures :all

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
    assert_equal cyrille, User.find_paying_member_by_name(cyrille.name)
    assert_equal nil, User.find_paying_member_by_name("Bla blabla")
  end
  
  def test_find_paying_member_by_name_with_middle_names
    norma = users(:norma)
    assert_equal norma, User.find_paying_member_by_name(norma.name)
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
  
  def test_make_resident_expert_from_free_listing
    rmoore = users(:rmoore)
    free_listing_role = roles(:free_listing_role)
    full_member_role = roles(:full_member_role)
    assert rmoore.roles.include?(free_listing_role)
    assert rmoore.free_listing?
    assert rmoore.tabs.size == 0
    kinesiology = subcategories(:kinesiology)
    rmoore.make_resident_expert!(kinesiology)
    rmoore.reload
    assert rmoore.resident_expert?
    assert_not_nil rmoore.expertise_subcategory
    assert_not_nil rmoore.resident_since
    assert_not_nil rmoore.resident_until
    assert !rmoore.free_listing?
    # IMPORTANT: if the user keeps the free listing role, it would appear twice in the search results
    assert !rmoore.roles.include?(free_listing_role)
    assert rmoore.roles.include?(full_member_role)
    assert rmoore.tabs.size > 0
  end

  def test_make_resident_expert_from_full_member
    norma = users(:norma)
    full_member_role = roles(:full_member_role)
    assert norma.roles.include?(full_member_role)
    kinesiology = subcategories(:kinesiology)
    norma.make_resident_expert!(kinesiology)
    assert norma.resident_expert?
    assert_not_nil norma.expertise_subcategory
    assert_not_nil norma.resident_since
    assert_not_nil norma.resident_until
    assert norma.roles.include?(full_member_role)
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

  def test_last_30days_redirect_website
    cyrille = users(:cyrille)
    assert_equal 1, cyrille.last_30days_redirect_website
  end

  def test_last_12months_redirect_website
    cyrille = users(:cyrille)
    assert_equal 2, cyrille.last_12months_redirect_website
  end

  def test_last_30days_received_messages
    cyrille = users(:cyrille)
    assert_equal 1, cyrille.last_30days_received_messages
  end

  def test_last_12months_received_messages
    cyrille = users(:cyrille)
    assert_equal 2, cyrille.last_12months_received_messages
  end

  def test_last_30days_profile_visits
    cyrille = users(:cyrille)
    assert_equal 1, cyrille.last_30days_profile_visits
  end

  def test_last_12_months_profile_visits
    cyrille = users(:cyrille)
    assert_equal 2, cyrille.last_12months_profile_visits
  end

  def test_invoices
    assert_equal 1, users(:cyrille).invoices.size
  end

  def test_role_description
    assert_equal "full member", users(:sgardiner).role_description
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

  def test_resident_experts
    resident_experts = []
    #build the list the slow way (with lots of users, it would very slow)
    User.all.each do |u|
      resident_experts << u if u.resident_expert? && !u.expertise_subcategory.blank?
    end
    #now make sure that the named_scope finds the same result
    assert_equal resident_experts.size, User.resident_experts.size
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

  def test_tab_change_on_update
    norma = users(:norma)
    spiritual_healing = subcategories(:spiritual_healing)
    old_subcategories = norma.subcategories
    old_tabs = norma.tabs
    old_first_tab = old_tabs[0]
    old_second_tab = old_tabs[1]
    
    norma.save
    norma.reload
    assert_equal 2, norma.tabs.size
    norma.subcategory1_id = old_subcategories[1].id
    norma.subcategory2_id = old_subcategories[0].id
    norma.save
    norma.reload

    assert_equal 2, norma.tabs.size
    #tab titles should have been swapped
    assert_equal old_subcategories[1].name, norma.tabs.first.title
    assert_equal old_subcategories[0].name, norma.tabs[1].title
    
    #tab content should be the same
    assert_equal old_first_tab.content, norma.tabs[1].content
    assert_equal old_second_tab.content, norma.tabs[0].content    
     
    norma.subcategory1_id = spiritual_healing.id
    norma.subcategory2_id = nil
    norma.save
    norma.reload
    assert_equal 1, norma.tabs.size
    assert_not_nil norma.tabs.first
    assert_equal spiritual_healing.name, norma.tabs.first.title
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
    assert "cyrille-bonnet", cyrille.slug
  end

  def test_articles
    cyrille = users(:cyrille)
    articles = cyrille.articles
    assert !articles.blank?
  end

  def test_newest_full_members
    cyrille = users(:cyrille)
    assert_equal [cyrille, users(:norma)], User.newest_full_members
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
    user = User.new(:first_name => "Joe", :last_name => "Test", :district_id => canterbury_christchurch_city.id,
      :region_id => canterbury.id, :email => "joe@test.com",
      :membership_type => "full_member", :professional => true, :subcategory1_id => hypnotherapy.id,
      :password => "blablabla", :password_confirmation => "blablabla", :accept_terms => true  )
      user.register!
      user.activate
      assert_equal 1, user.roles.find_all_by_name("full_member").size
      assert_equal old_roles_user_size+1, RolesUser.all.size
  end
    
  def test_unique_tab_title
    cyrille = users(:cyrille)
    old_size = Tab.all.size
    cyrille.add_tab("Test", "Content")
    assert_equal old_size+1, Tab.all.size
    cyrille.add_tab("Test", "Content")
    #no new tab created: the title of the 2nd tab is not unique
    assert_equal old_size+1, Tab.all.size
  end

  def test_change_membership
    canterbury_christchurch_city = districts(:canterbury_christchurch_city)
    canterbury = regions(:canterbury)
    hypnotherapy = subcategories(:hypnotherapy)
    user = User.new(:first_name => "Joe", :last_name => "Test",
      :district_id => canterbury_christchurch_city.id, :business_name => "uytut",
      :region_id => canterbury.id, :email => "joe.bill@nunu.com",
      :free_listing => true, :professional => true,
      :password => "blablabla", :password_confirmation => "blablabla", :subcategory1_id => hypnotherapy.id )
    user.register!
    user.activate!
    assert_equal 0, user.tabs.size
    user.membership_type = "full_member"
    user.save!
    user.reload
    assert_equal 1, user.tabs.size
    assert_equal "Hypnotherapy", user.tabs.first.title
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
		assert_equal 4, res.size
	end

	def test_all_find_by_subcategories
		yoga = subcategories(:yoga)
		hypnotherapy = subcategories(:hypnotherapy)
		res = User.find_all_by_subcategories(hypnotherapy)
		assert_equal 5, res.size
		res = User.find_all_by_subcategories(hypnotherapy, yoga)
		assert_equal 5, res.size
	end

	def test_count_all_by_subcategories
		yoga = subcategories(:yoga)
		hypnotherapy = subcategories(:hypnotherapy)
		res = User.count_all_by_subcategories(hypnotherapy)
		assert_equal 5, res
		res = User.count_all_by_subcategories(hypnotherapy, yoga)
		assert_equal 5, res
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
    practitioners = categories(:practitioners)
		assert_equal [hypnotherapy], rmoore.subcategories
		test_user = User.find_by_email(rmoore.email)
		assert_equal [hypnotherapy], test_user.subcategories
    assert_equal [practitioners], test_user.categories
	end

	def test_create_without_subcategories
		wellington = regions(:wellington)
		wellington_wellington_city = districts(:wellington_wellington_city)

		new_user = User.new(:accept_terms => "1", :first_name => "Joe", :last_name => "Test", :business_name => "Test",
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
		new_user = User.new(:first_name => "Joe", :last_name => "Test", :business_name => "   Test",
			:address1 => "1, Main St", :suburb => "Newtown", :district_id => wellington_wellington_city.id,
			:region_id => wellington.id, :phone => "04-28392173", :mobile => "", :email => "joe@test.com",
			:subcategory1_id => hypnotherapy.id, :subcategory2_id => yoga.id, :subcategory3_id => nil,
			:password => "blablabla", :password_confirmation => "blablabla"  )
		new_user.register!
		new_user.activate!
		assert_equal old_count+1, User.count
		assert_equal [hypnotherapy, yoga], new_user.subcategories
		new_user2 = User.find_by_email("joe@test.com")
		assert_equal [hypnotherapy, yoga], new_user2.subcategories
    assert_not_nil new_user.user_profile
    assert_not_nil new_user.latitude
    assert_not_nil new_user.longitude
	end
end