require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase
	fixtures :all

  def test_edit
    cyrille = users(:cyrille)
    get :edit, {}, {:user_id => cyrille.id }
    assert_response :success
    assert_select "input[type=radio][value=full_member][checked]"
  end

  def test_profile_full_member
    cyrille = users(:cyrille)
    get :profile, {}, {:user_id => cyrille.id }
    assert_response :success
  end

  def test_profile_full_member
    amcloughlin = users(:amcloughlin)
    get :profile, {}, {:user_id => amcloughlin.id }
    assert_response :unauthorized
  end

  def test_new_photo
    cyrille = users(:cyrille)
    get :new_photo, {}, {:user_id => cyrille.id }
    assert_response :success
    #make sure that we don't have a layout as it only used as AJAX
    assert_select "div#header", :count => 0
  end

	def test_publish
		norma = users(:norma)
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

		post :publish, {}, {:user_id => norma.id}
		norma.user_profile.reload
		assert_not_nil norma.user_profile.published_at

    # #an email should be sent to reviewers
		assert ActionMailer::Base.deliveries.size > 0
	end
  
  def test_show
    old_size = UserEvent.all.size
    rmoore = users(:rmoore)
    cyrille = users(:cyrille)

    get :show, {:id => rmoore.slug}, {:user_id => rmoore.id }
    # #visits to own profile should not be recorded
    assert_equal old_size, UserEvent.all.size
    get :show, {:id => cyrille.slug}, {:user_id => rmoore.id }
    assert_equal old_size+1, UserEvent.all.size

  end

  def test_show2
    sgardiner = users(:sgardiner)
    get :show, {:id => sgardiner.slug}, {:user_id => sgardiner.id }
    assert_select "input[value=Publish]"
    assert_select "a[href=/tabs/create]"
  end

  def test_show3
    cyrille = users(:cyrille)
    get :show, {:id => cyrille.slug}, {:user_id => cyrille.id }
    # #Cyrille's profile is already published: not button should be shown
    assert_select "input[value=Publish]", :count => 0
  end

  def test_show_free_listing
    amcloughlin = users(:amcloughlin)
    get :show, {:id => amcloughlin.slug}, {:user_id => amcloughlin.id }
    assert_select "a[href=/tabs/create]", 0
  end

	def test_update_password
		cyrille = users(:cyrille)
		post :update_password, {:user => {:password => "bleblete", :password_confirmation => "bleblete"  }}, {:user_id => cyrille.id }
		assert_equal "Your password has been updated", flash[:notice]
		assert_not_nil User.authenticate(cyrille.email, "bleblete")
	end

	def test_update_phone
		cyrille = users(:cyrille)
    
		post :update, {:id => "123", :user => {:phone_prefix => "06", :phone_suffix => "999999" }}, {:user_id => cyrille.id }
		assert_equal "Your details have been updated", flash[:notice]
    cyrille.reload
		assert_equal "06-999999", cyrille.phone
  end
  
	def test_update_phone2
    rmoore = users(:rmoore)
		post :update, {:id => "123", :user => {:business_name => "My biz", :phone_prefix => "09", :phone_suffix => "111111" }}, {:user_id => rmoore.id }
    #    puts assigns(:user).errors.inspect
		assert_equal "Your details have been updated", flash[:notice]
    rmoore.reload
		assert_equal "09-111111", rmoore.phone
	end

	def test_update_mobile
		cyrille = users(:cyrille)

		post :update, {:id => "123", :user => {:mobile_prefix => "027", :mobile_suffix => "999999" }}, {:user_id => cyrille.id }
		assert_equal "Your details have been updated", flash[:notice]
    cyrille.reload
		assert_equal "027-999999", cyrille.mobile
	end

	def test_update_mobile2
    rmoore = users(:rmoore)

		post :update, {:id => "123", :user => {:business_name => "My biz", :mobile_prefix => "021", :mobile_suffix => "999999" }}, {:user_id => rmoore.id }
		assert_equal "Your details have been updated", flash[:notice]
    rmoore.reload
		assert_equal "021-999999", rmoore.mobile
	end

	def test_update_mobile3
    norma = users(:norma)

		post :update, {:id => "123", :user => {:mobile_prefix => "021", :mobile_suffix => "999999" }}, {:user_id => norma.id }
		assert_equal "Your details have been updated", flash[:notice]
    norma.reload
		assert_equal "021-999999", norma.mobile
	end

  def test_create
		old_size = User.all.size
		district = District.first
    hypnotherapy = subcategories(:hypnotherapy)
		post :create, :user => {:email => "cyrille@stuff.com", :password => "testtest23", :first_name => "Cyrille", :last_name => "Stuff",
      :password_confirmation => "testtest23", :district_id => district.id, :membership_type => "free_listing",
      :subcategory1_id => hypnotherapy.id
      }
		assert_not_nil assigns(:user)
#    puts assigns(:user).errors.inspect
		assert_equal 0, assigns(:user).errors.size
		assert_equal old_size+1, User.all.size
	end
  def test_create_free_listing
		old_size = User.all.size
		district = districts(:wellington_wellington_city)
		wellington = regions(:wellington)
    hypnotherapy = subcategories(:hypnotherapy)
		post :create, :user => {:email => "cyrille@stuff.com", :password => "testtest23",
      :password_confirmation => "testtest23", :professional => true, :district_id => district.id, :mobile_prefix => "027",
      :mobile_suffix => "8987987", :first_name => "Cyrille", :last_name => "Stuff", :membership_type => "free_listing",
      :subcategory1_id => hypnotherapy.id }
		assert_not_nil assigns(:user)
    # # 	puts assigns(:user).errors.inspect
		assert_equal 0, assigns(:user).errors.size
		assert_equal old_size+1, User.all.size
		new_user = User.find_by_email("cyrille@stuff.com")
		assert_not_nil(new_user)
		assert_equal "027-8987987", new_user.mobile
		assert_equal wellington, new_user.region
	end
  def test_create_full_membership
		old_size = User.all.size
		district = districts(:wellington_wellington_city)
		wellington = regions(:wellington)
    hypnotherapy = subcategories(:hypnotherapy)
		post :create, :user => {:email => "cyrille@stuff.com", :password => "testtest23",
      :password_confirmation => "testtest23", :professional => true, :district_id => district.id, :mobile_prefix => "027",
      :mobile_suffix => "8987987", :first_name => "Cyrille", :last_name => "Stuff", :membership_type => "full_member", :subcategory1_id => hypnotherapy.id   }
    assert_redirected_to "payments/new?payment_type=full_member"
		assert_not_nil assigns(:user)
    # # 	puts assigns(:user).errors.inspect
		assert_equal 0, assigns(:user).errors.size
		assert_equal old_size+1, User.all.size
		new_user = User.find_by_email("cyrille@stuff.com")
		assert_not_nil(new_user)
		assert_equal "027-8987987", new_user.mobile
		assert_equal wellington, new_user.region
    # #2 tabs: one for about cyrille and one for hypnotherapy
    assert_equal 2, new_user.tabs.size
	end
end
