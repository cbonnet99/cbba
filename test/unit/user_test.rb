require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase

	fixtures :all

	def test_has_role
		sgardiner = users(:sgardiner)
		assert sgardiner.has_role?('full_member')
	end

	def test_search_results
		practitioners = categories(:practitioners)
		hypnotherapy = subcategories(:hypnotherapy)
		canterbury_christchurch_city = districts(:canterbury_christchurch_city)
		assert_equal 2, User.search_results(practitioners.id, hypnotherapy.id, nil, canterbury_christchurch_city.id).size
	end

	def test_search_results_category
		practitioners = categories(:practitioners)
		canterbury_christchurch_city = districts(:canterbury_christchurch_city)
		assert_equal 2, User.search_results(practitioners.id, nil, nil, canterbury_christchurch_city.id).size
	end

	def test_search_results_category_region
		practitioners = categories(:practitioners)
		canterbury = regions(:canterbury)
		assert_equal 3, User.search_results(practitioners.id, nil, canterbury.id, nil).size
	end

	def test_create
		wellington = regions(:wellington)
		wellington_wellington_city = districts(:wellington_wellington_city)
		hypnotherapy = subcategories(:hypnotherapy)
		yoga = subcategories(:yoga)

		old_count = User.count
		User.create(:first_name => "Joe", :last_name => "Test", :business_name => "Test",
			:address1 => "1, Main St", :suburb => "Newtown", :district_id => wellington_wellington_city.id,
			:region_id => wellington.id, :phone => "04-28392173", :mobile => "", :email => "joe@test.com",
			:subcategory1_id => hypnotherapy.id, :subcategory2_id => yoga.id, :subcategory3_id => nil,
			:password => "blablabla", :password_confirmation => "blablabla"  )
		assert_equal old_count+1, User.count
		new_user = User.find_by_email("joe@test.com")
		assert_equal yoga.name, new_user.subcategory2.name
	end
end