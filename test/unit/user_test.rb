require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
	
	def test_create
		wellington = regions(:wellington)
		wellington_wellington_city = districts(:wellington_wellington_city)
		test = categories(:test)
		yoga = categories(:yoga)
		naturopath = categories(:naturopath)

		old_count = User.count
		User.create(:first_name => "Joe", :last_name => "Test", :business_name => "Test",
			:address1 => "1, Main St", :suburb => "Newtown", :district_id => wellington_wellington_city.id,
			:region_id => wellington.id, :phone => "04-28392173", :mobile => "", :email => "joe@test.com",
			:category1_id => test.id, :category2_id => yoga.id, :category3_id => naturopath.id,
			:password => "blablabla", :password_confirmation => "blablabla"  )
		assert_equal old_count+1, User.count
	end
end