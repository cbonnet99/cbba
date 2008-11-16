require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase
	fixtures :all

	def test_update_password
		cyrille = users(:cyrille)
		post :update_password, {:user => {:password => "bleblete", :password_confirmation => "bleblete"  }}, {:user_id => cyrille.id }
		assert_equal "Your password has been updated", flash[:notice]
		assert_not_nil User.authenticate(cyrille.email, "bleblete")
	end
	
  def test_create
		old_size = User.all.size
		district = District.first
		post :create, :user => {:email => "cyrille@stuff.com", :password => "testtest23",
		 :password_confirmation => "testtest23", :district_id => district.id}
		assert_not_nil assigns(:user)
#		puts assigns(:user).errors.inspect
		assert_equal 0, assigns(:user).errors.size
		assert_equal old_size+1, User.all.size
	end
  def test_create_free_listing
		old_size = User.all.size
		district = districts(:wellington_wellington_city)
		wellington = regions(:wellington)
		post :create, :user => {:email => "cyrille@stuff.com", :password => "testtest23",
		 :password_confirmation => "testtest23", :professional => true,
		 :free_listing => true, :district_id => district.id, :mobile_prefix => "027",
		 :mobile_suffix => "8987987", :business_name => "My biz"  }
		assert_not_nil assigns(:user)
#		puts assigns(:user).errors.inspect
		assert_equal 0, assigns(:user).errors.size
		assert_equal old_size+1, User.all.size
		new_user = User.find_by_email("cyrille@stuff.com")
		assert_not_nil(new_user)
		assert_equal "027-8987987", new_user.mobile
		assert_equal wellington, new_user.region
	end
end
