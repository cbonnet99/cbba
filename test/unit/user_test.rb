require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase

	fixtures :all
  
#  def test_position_search
#
#        puts "============ new_results:"
#    new_results.each do |r|
#      puts "+++++++++ #{r.email} (#{r.free_listing})"
#    end
#    puts "============ after_insert_results:"
#    after_insert_results.each do |r|
#      puts "+++++++++ #{r.email} (#{r.free_listing})"
#    end
#
#  end

	def test_reviewers
		assert_equal 1, User.reviewers.size
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
		assert_equal 4, res.size
		res = User.find_all_by_subcategories(hypnotherapy, yoga)
		assert_equal 4, res.size
	end

	def test_count_all_by_subcategories
		yoga = subcategories(:yoga)
		hypnotherapy = subcategories(:hypnotherapy)
		res = User.count_all_by_subcategories(hypnotherapy)
		assert_equal 4, res
		res = User.count_all_by_subcategories(hypnotherapy, yoga)
		assert_equal 4, res
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
	end
end