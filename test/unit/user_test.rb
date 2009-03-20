require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase

	fixtures :all

  def test_css_class_role_description
    #if you change any below, make sure that the name is changed in the CSS
    assert_equal "title-user-free-listing", users(:rmoore).css_class_role_description
    assert_equal "title-user-full-member", users(:sgardiner).css_class_role_description
  end

  def test_contact_details
    assert_equal "06-3086130", users(:cyrille).contact_details
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
    assert_equal "Bookings can be made by phone or email:<br/>06-3086130<br/>cbonnet99@gmail.com", cyrille.default_how_to_book
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
    assert_equal "4 items to review", cyrille.sentence_to_review
  end

  def test_roles
    canterbury_christchurch_city = districts(:canterbury_christchurch_city)
    canterbury = regions(:canterbury)
    hypnotherapy = subcategories(:hypnotherapy)
    old_roles_user_size = RolesUser.all.size
    user = User.new(:first_name => "Joe", :last_name => "Test", :district_id => canterbury_christchurch_city.id,
      :region_id => canterbury.id, :email => "joe@test.com",
      :membership_type => "full_member", :professional => true, :subcategory1_id => hypnotherapy.id,
      :password => "blablabla", :password_confirmation => "blablabla" )
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
    assert_equal 2, user.tabs.size
    assert_equal "Hypnotherapy", user.tabs.first.title
    assert_equal "About Joe", user.tabs.last.title
    user.update_attributes(:last_name => "Test2")
    user.reload
    assert_equal 2, user.tabs.size
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

	def test_search_results_category
		practitioners = categories(:practitioners)
		canterbury_christchurch_city = districts(:canterbury_christchurch_city)
    results = User.search_results(practitioners.id, nil, nil, canterbury_christchurch_city.id, 1)
#    puts "========= results:"
#    results.each do |r|
#      puts r.name
#    end
		assert_equal 3, results.size
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

		new_user = User.new(:first_name => "Joe", :last_name => "Test", :business_name => "Test",
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
		new_user = User.new(:first_name => "Joe", :last_name => "Test", :business_name => "Test",
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