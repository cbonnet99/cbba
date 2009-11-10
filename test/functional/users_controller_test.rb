require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase
	fixtures :all
	include ApplicationHelper

  def test_unsubscribe
    norma = users(:norma)
    assert norma.receive_newsletter?
    get :unsubscribe, :token => norma.unsubscribe_token, :slug => norma.slug 
    assert_response :success
    assert_template 'unsubscribe_success'
    norma.reload
    assert !norma.receive_newsletter?
  end

  def test_unsubscribe_failure
    norma = users(:norma)
    assert norma.receive_newsletter?
    get :unsubscribe, :token => "bla", :slug => norma.slug 
    assert_response :success
    assert_template 'unsubscribe_failure'
    norma.reload
    assert norma.receive_newsletter?
  end

  def test_intro
    get :intro
    assert_response :success
  end

  def test_message
    get :message, :slug => users(:cyrille).slug 
    assert_response :success
  end

  def test_more_about_free_listing
    get :more_about_free_listing
    assert_response :success
    #just to check that the HTML is valid
    assert_select "div"
  end

  def test_stats
    get :stats, {}, {:user_id => users(:cyrille).id }
  end

  def test_redirect_website
    cyrille = users(:cyrille)
    old_events_size = UserEvent.all.size
    post :redirect_website, :slug => cyrille.slug
    assert_equal old_events_size+1, UserEvent.all.size
    last_event = UserEvent.find(:first, :order => "logged_at desc")
    assert_equal cyrille.id, last_event.visited_user_id
    assert_equal UserEvent::REDIRECT_WEBSITE, last_event.event_type
  end

  def test_redirect_website2
    norma = users(:norma)
    old_events_size = UserEvent.all.size
    post :redirect_website, :slug => norma.slug
    assert_equal old_events_size+1, UserEvent.all.size
    last_event = UserEvent.find(:first, :order => "logged_at desc")
    assert_equal norma.id, last_event.visited_user_id
    assert_equal UserEvent::REDIRECT_WEBSITE, last_event.event_type
  end

  def test_redirect_website_unknown_user
    cyrille = users(:cyrille)
    post :redirect_website, :slug => "bla"
    assert_redirected_to root_url
  end

  def test_create_resident_expert
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
		old_size = ExpertApplication.all.size
		district = districts(:wellington_wellington_city)
    hypnotherapy = subcategories(:hypnotherapy)
		post :create, :user => {:email => "cyrille@stuff.com", :password => "testtest23",
      :password_confirmation => "testtest23", :professional => true, :district_id => district.id, :mobile_prefix => "027",
      :accept_terms => "1", :mobile_suffix => "8987987", :first_name => "Cyrille", :last_name => "Stuff", :membership_type => "resident_expert", :subcategory1_id => hypnotherapy.id   }
    assert_redirected_to new_expert_application_url
	end

  def test_membership_free_listing
    rmoore = users(:rmoore)
    get :membership, {}, {:user_id => rmoore.id }
    assert_response :success
    assert_nil assigns(:payment)
    assert_match %r{You have a free membership}, @response.body
  end

  def test_membership_full
    sgardiner = users(:sgardiner)
    get :membership, {}, {:user_id => sgardiner.id }
    assert_response :success
    assert_nil assigns(:payment)
    assert_match %r{You are a full member of BeAmazing since}, @response.body
    assert_match %r{Your membership is valid until}, @response.body
  end

  def test_membership_resident_expert
    resident_expert_user = users(:resident_expert_user)
    get :membership, {}, {:user_id => resident_expert_user.id }
    assert_response :success
    # assert_not_nil assigns(:payment)
    assert_no_match %r{You have applied to become a resident expert}, @response.body
    assert_match %r{You are a resident expert}, @response.body
  end

  def test_membership_applying_resident_expert
    applying_resident_expert = users(:applying_resident_expert)
    get :membership, {}, {:user_id => applying_resident_expert.id }
    assert_response :success
    assert_match %r{You have applied to become a resident expert}, @response.body
    assert_no_match %r{You are a resident expert}, @response.body
  end

  def test_membership_new_pending
    pending_user = users(:pending_user)
    get :membership, {}, {:user_id => pending_user.id }
    assert_response :success
    assert_not_nil assigns(:payment)
    assert_match %r{Your membership has not been activated yet}, @response.body
  end

  def test_membership_renew_pending
    suspended_user1 = users(:suspended_user1)
    get :membership, {}, {:user_id => suspended_user1.id }
    assert_response :success
    assert_nil assigns(:payment)
    assert_match %r{Your membership has expired}, @response.body
  end

  def test_renew_membership
    cyrille = users(:cyrille)
    old_payments_size = cyrille.payments.size
    post :renew_membership, {}, {:user_id => cyrille.id }
    assert_not_nil assigns(:payment)
    assert_equal 19900, assigns(:payment).amount
    assert_redirected_to edit_payment_url(assigns(:payment))
    cyrille.reload
    assert_equal old_payments_size+1, cyrille.payments.size
    
    #the 2nd time, now payment should be created
    post :renew_membership, {}, {:user_id => cyrille.id }
    assert_not_nil assigns(:payment)
    assert_redirected_to edit_payment_url(assigns(:payment))
    cyrille.reload
    assert_equal old_payments_size+1, cyrille.payments.size

  end

  def test_index
    get :index
    assert_response :success
    assert !assigns(:full_members).blank?
  end

  def test_edit
    cyrille = users(:cyrille)
    get :edit, {}, {:user_id => cyrille.id }
    assert_response :success
  end

  def test_new_photo
    cyrille = users(:cyrille)
    get :new_photo, {}, {:user_id => cyrille.id }
    assert_response :success
    #make sure that we don't have a layout as it only used as AJAX
    assert_select "div#header", :count => 0
  end

	def test_publish
		sgardiner = users(:sgardiner)
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

		post :publish, {}, {:user_id => sgardiner.id}
		sgardiner.user_profile.reload
		assert_not_nil sgardiner.user_profile.published_at

    # #an email should be sent to reviewers
		assert ActionMailer::Base.deliveries.size > 0
	end
  
  def test_show_special_offers
    auckland = regions(:auckland)
    coaches = categories(:coaches)
    norma = users(:norma)

    get :show, {:name => norma.slug, :region => auckland.slug, :main_expertise_slug => coaches.slug, :selected_tab_id => "offers" }
    assert_not_nil assigns(:all_offers)
    assert_select "span", {:text => "published", :count => 0} 
  end

  def test_show_special_offers_own_profile
    auckland = regions(:auckland)
    coaches = categories(:coaches)
    norma = users(:norma)

    get :show, {:name => norma.slug, :region => auckland.slug, :main_expertise_slug => coaches.slug, :selected_tab_id => "offers"}, {:user_id => norma.id}
    assert_not_nil assigns(:all_offers)
    # assert_select "span", {:text => "published", :count => 2} 
  end

  def test_show_articles
    auckland = regions(:auckland)
    coaches = categories(:coaches)
    cyrille = users(:cyrille)

    get :show, {:name => cyrille.slug, :region => auckland.slug, :main_expertise_slug => coaches.slug, :selected_tab_id => "articles" }
    assert_not_nil assigns(:all_articles)
    #it shows both articles and how tos
    assert_equal 2, assigns(:all_articles).size
    assert_select "div.by-author", {:count => 0}, "Author should not be shown as the articles are shown in the profile"
  end

  def test_show_own_articles
    auckland = regions(:auckland)
    coaches = categories(:coaches)
    cyrille = users(:cyrille)

    get :show, {:name => cyrille.slug, :region => auckland.slug, :main_expertise_slug => coaches.slug, :selected_tab_id => "articles" }, {:user_id => cyrille.id}
    assert_not_nil assigns(:all_articles)
    #it shows both articles and how tos
    assert_equal 4, assigns(:all_articles).size
    assert_select "div.by-author", {:count => 0}, "Author should not be shown, as it is the current user"
    assert_select "span.workflow-draft", {:count => 2}, "Article state should be shown"
  end

  def test_show
    old_size = UserEvent.all.size
    rmoore = users(:rmoore)
    cyrille = users(:cyrille)
    auckland = regions(:auckland)
    coaches = categories(:coaches)

    get :show, {:name => rmoore.slug, :region => auckland.slug, :main_expertise_slug => coaches.slug}, {:user_id => rmoore.id }
    # #visits to own profile should not be recorded
    assert_equal old_size, UserEvent.all.size
    get :show, {:name => cyrille.slug, :region => auckland.slug, :main_expertise_slug => coaches.slug}, {:user_id => rmoore.id }
    assert_equal old_size+1, UserEvent.all.size
  end

  def test_show2
    sgardiner = users(:sgardiner)
    auckland = regions(:auckland)
    coaches = categories(:coaches)
    get :show, {:name => sgardiner.slug, :region => auckland.slug, :main_expertise_slug => coaches.slug  }, {:user_id => sgardiner.id }
    assert_select "input[value=Publish]"
  end

  def test_show3
    cyrille = users(:cyrille)
    wellington = regions(:wellington)
    practitioners = categories(:practitioners)
    get :show, {:name => cyrille.slug, :region => wellington.slug, :main_expertise_slug => practitioners.slug}, {:user_id => cyrille.id }
    assert_response :success
    # #Cyrille's profile is already published: Unpublish button should be shown
    assert_select "input[value=Publish]", :count => 0
    assert_select "input[value=Unpublish]"
    #counts both articles and 'how to' articles
    assert_select "a", :text => "4 articles"
    assert_select "a", :text => "4 offers"
  end

  def test_show_not_own_profile
    cyrille = users(:cyrille)
    norma = users(:norma)
    auckland = regions(:auckland)
    coaches = categories(:coaches)
    get :show, {:name => cyrille.slug, :region => auckland.slug, :main_expertise_slug => coaches.slug}, {:user_id => norma.id }
    assert_response :success
    # #Cyrille's profile is already published: Unpublish button should be shown
   # puts @response.body
    assert_select "input[value=Publish]", :count => 0
    assert_select "input[value=Unpublish]", :count => 0
    #only one published article
    assert_select "a", :text => "1 article"
    
    #only one published special offer and one published gift voucher
    assert_select "a", :text => "2 offers"
  end

  def test_show_number_published_articles
    cyrille = users(:cyrille)
    auckland = regions(:auckland)
    coaches = categories(:coaches)
    get :show, {:name => cyrille.slug, :region => auckland.slug, :main_expertise_slug => coaches.slug}
    assert_response :success
    assert_select "a", :text => "1 article"
    assert_select "a", :text => "2 offers"
  end

  def test_show_always_show_articles_when_own_profile
    norma = users(:norma)
    auckland = regions(:auckland)
    coaches = categories(:coaches)
    get :show, {:name => norma.slug, :region => auckland.slug, :main_expertise_slug => coaches.slug}, {:user_id => norma.id }
    assert_response :success
    # puts @response.body
    assert_select "a", :text => "0 articles"
    assert_select "a", :text => "3 offers"
  end

  def test_show_hide_articles_when_0
    norma = users(:norma)
    auckland = regions(:auckland)
    coaches = categories(:coaches)
    get :show, {:name => norma.slug, :region => auckland.slug, :main_expertise_slug => coaches.slug}
    assert_response :success
    assert_select "a", :text => "0 articles", :count => 0
    assert_select "a", :text => "0 offers", :count => 0
  end

  def test_show_free_listing
    amcloughlin = users(:amcloughlin)
    get :show, {:id => amcloughlin.slug}, {:user_id => amcloughlin.id }
    assert_select "a[href=/tabs/create]", 0
  end

  def test_show_draft_profile
    sgardiner = users(:sgardiner)
    cyrille = users(:cyrille)
    auckland = regions(:auckland)
    coaches = categories(:coaches)

    get :show, {:name => sgardiner.slug, :region => auckland.slug, :main_expertise_slug => coaches.slug}, {:user_id => cyrille.id }
#    puts "============= #{@response.body}"
    assert @response.body =~ /Profile coming soon/
    assert_no_match %r{To make it public, click on Publish}, @response.body
  end

  def test_show_how_to
    improve = how_tos(:improve)
    money = how_tos(:money)
    cyrille = users(:cyrille)
    auckland = regions(:auckland)
    coaches = categories(:coaches)

    get :show, {:name => cyrille.slug, :region => auckland.slug, :main_expertise_slug => coaches.slug, :selected_tab_id => Tab::ARTICLES, }, {:user_id => cyrille.id }
    assert !assigns(:all_articles).blank?
    assert assigns(:all_articles).include?(improve)
    assert assigns(:all_articles).include?(money)
  end
  
  def test_show_how_to_for_anonymous_users
    improve = how_tos(:improve)
    money = how_tos(:money)
    long = articles(:long)
    cyrille = users(:cyrille)
    auckland = regions(:auckland)
    coaches = categories(:coaches)
    
    get :show, {:name => cyrille.slug, :region => auckland.slug, :main_expertise_slug => coaches.slug, :selected_tab_id => Tab::ARTICLES, }, { }
    assert !assigns(:all_articles).blank?
    assert assigns(:all_articles).include?(money)
    assert !assigns(:all_articles).include?(improve)
    assert assigns(:all_articles).index(money) < assigns(:all_articles).index(long)
  end

	def test_update_password
		cyrille = users(:cyrille)
		post :update_password, {:user => {:old_password => "monkey", :password => "bleblete", :password_confirmation => "bleblete"  }}, {:user_id => cyrille.id }
		assert_equal "Your password has been updated", flash[:notice]
		assert_not_nil User.authenticate(cyrille.email, "bleblete")
	end

	def test_update_password_wrong_old_password
		cyrille = users(:cyrille)
		post :update_password, {:user => {:old_password => "blabla", :password => "bleblete", :password_confirmation => "bleblete"  }}, {:user_id => cyrille.id }
		assert_equal "Sorry, your password could not be changed", flash[:error]
		assert_nil User.authenticate(cyrille.email, "bleblete")
	end

	def test_update_phone
		cyrille = users(:cyrille)
		post :update, {:id => "123", :user => {:phone_prefix => "06", :phone_suffix => "999999" }}, {:user_id => cyrille.id }
		assert_redirected_to expanded_user_url(cyrille)
		assert_equal "Your details have been updated", flash[:notice]
    cyrille.reload
		assert_equal "(06)999999", cyrille.phone
  end
  
	def test_update_phone2
    rmoore = users(:rmoore)
		post :update, {:id => "123", :user => {:business_name => "My biz", :phone_prefix => "09", :phone_suffix => "111111" }}, {:user_id => rmoore.id }
    #    puts assigns(:user).errors.inspect
		assert_equal "Your details have been updated", flash[:notice]
    rmoore.reload
		assert_equal "(09)111111", rmoore.phone
	end

	def test_update_email
    rmoore = users(:rmoore)
		post :update, {:id => "123", :user => {:email  => "my_new_address@test.com" }}, {:user_id => rmoore.id }
    #    puts assigns(:user).errors.inspect
		assert_equal "Your details have been updated", flash[:notice]
    rmoore.reload
		assert_equal "my_new_address@test.com", rmoore.email
	end

	def test_update_mobile
		cyrille = users(:cyrille)
    TaskUtils.rotate_user_positions_in_subcategories
    cyrille.subcategories_users.reload
    assert_not_nil cyrille.subcategories_users[0]
    #position should not be nil
    assert_not_nil cyrille.subcategories_users[0].position
    old_position = cyrille.subcategories_users[0].position
		post :update, {:id => "123", :user => {:mobile_prefix => "027", :mobile_suffix => "999999" }}, {:user_id => cyrille.id }
		assert_equal "Your details have been updated", flash[:notice]
    cyrille = User.find_by_email(cyrille.email)
		assert_equal "(027)999999", cyrille.mobile
    assert !cyrille.subcategories_users.blank?
    assert_not_nil cyrille.subcategories_users[0]
    #position should stay unchanged
    assert_not_nil cyrille.subcategories_users[0].position
    assert_equal old_position, cyrille.subcategories_users[0].position
	end

  def test_update_main_expertise
    sgardiner = users(:sgardiner)
    hypnotherapy = subcategories(:hypnotherapy)
    aromatherapy = subcategories(:aromatherapy)
    assert_equal hypnotherapy.name, sgardiner.main_expertise_name
		post :update, {:id => "123", :user => {:subcategory1_id => aromatherapy.id, :subcategory2_id => hypnotherapy.id}}, {:user_id => sgardiner.id }
    assert_equal 0, assigns(:user).errors.size
    sgardiner.subcategories_users.reload

    #IMPORTANT: do not reload as the reload does not go through the after_find callback...
    sgardiner = User.find_by_email(sgardiner.email)
    assert_equal aromatherapy.id, sgardiner.subcategory1_id
    assert_equal aromatherapy.name, sgardiner.main_expertise_name
  end

  def test_update_tabs
    norma = users(:norma)
    yoga = subcategories(:yoga)
		post :update, {:id => "123", :user => {:subcategory1_id => yoga.id, :subcategory2_id => nil }}, {:user_id => norma.id }
    assert_equal 0, assigns(:user).errors.size
    norma.reload
    
    assert_equal 1, norma.tabs.size
    assert_equal yoga.name, norma.tabs[0].title
    

    #IMPORTANT: do not reload as the reload does not go through the after_find callback...
    # sgardiner = User.find_by_email(sgardiner.email)
    # assert_equal aromatherapy.id, sgardiner.subcategory1_id
    # assert_equal aromatherapy.name, sgardiner.main_expertise
  end

	def test_update_mobile2
    rmoore = users(:rmoore)

		post :update, {:id => "123", :user => {:business_name => "My biz", :mobile_prefix => "021", :mobile_suffix => "999999" }}, {:user_id => rmoore.id }
		assert_equal "Your details have been updated", flash[:notice]
    rmoore.reload
		assert_equal "(021)999999", rmoore.mobile
	end

	def test_update_mobile3
    norma = users(:norma)

		post :update, {:id => "123", :user => {:mobile_prefix => "021", :mobile_suffix => "999999" }}, {:user_id => norma.id }
		assert_equal "Your details have been updated", flash[:notice]
    norma.reload
		assert_equal "(021)999999", norma.mobile
	end

  def test_create
		old_size = User.all.size
		district = District.first
    hypnotherapy = subcategories(:hypnotherapy)
		post :create, :user => {:email => "cyrille@stuff.com", :password => "testtest23", :first_name => "Cyrille", :last_name => "Stuff",
      :password_confirmation => "testtest23", :district_id => district.id, :membership_type => "free_listing",
      :accept_terms => "1", :subcategory1_id => hypnotherapy.id
      }
		assert_not_nil assigns(:user)
#    puts assigns(:user).errors.inspect
		assert_equal 0, assigns(:user).errors.size
		assert_equal old_size+1, User.all.size
	end
  def test_create_with_same_name
		district = District.first
    hypnotherapy = subcategories(:hypnotherapy)
		post :create, :user => {:email => "cyrille@stuff.com", :password => "testtest23", :first_name => "Cyrille", :last_name => "Bonnet",
      :password_confirmation => "testtest23", :district_id => district.id, :membership_type => "free_listing",
      :accept_terms => "1", :subcategory1_id => hypnotherapy.id, :business_name => "Bioboy Inc", :professional => true,
      }
		assert_not_nil assigns(:user)
#    puts assigns(:user).errors.inspect
		assert_equal 1, assigns(:user).errors.size
	end
  def test_create_free_listing
		old_size = User.all.size
		district = districts(:wellington_wellington_city)
		wellington = regions(:wellington)
    hypnotherapy = subcategories(:hypnotherapy)
		post :create, :user => {:email => "cyrille@stuff.com", :password => "testtest23",
      :password_confirmation => "testtest23", :professional => true, :district_id => district.id, :mobile_prefix => "027",
      :mobile_suffix => "8987987", :first_name => "Cyrille", :last_name => "Stuff", :membership_type => "free_listing",
      :accept_terms => "1", :subcategory1_id => hypnotherapy.id }
    assert_redirected_to user_membership_url
		assert_not_nil assigns(:user)
    # # 	puts assigns(:user).errors.inspect
		assert_equal 0, assigns(:user).errors.size
		assert_equal old_size+1, User.all.size
		new_user = User.find_by_email("cyrille@stuff.com")
		assert_not_nil(new_user)
		assert_equal "(027)8987987", new_user.mobile
		assert_equal wellington, new_user.region
    assert new_user.active?
	end
	
  def test_create_full_membership
		old_size = User.all.size
		district = districts(:wellington_wellington_city)
		wellington = regions(:wellington)
    hypnotherapy = subcategories(:hypnotherapy)
		post :create, :user => {:email => "cyrille@stuff.com", :password => "testtest23",
      :password_confirmation => "testtest23", :professional => true, :district_id => district.id, :mobile_prefix => "027",
      :accept_terms => "1", :mobile_suffix => "8987987", :first_name => "Cyrille", :last_name => "Stuff", :membership_type => "full_member", :subcategory1_id => hypnotherapy.id   }
    assert_not_nil assigns(:payment)
    assert_redirected_to edit_payment_url(assigns(:payment))
		assert_not_nil assigns(:user)
    # # 	puts assigns(:user).errors.inspect
		assert_equal 0, assigns(:user).errors.size
		assert_equal old_size+1, User.all.size
		new_user = User.find_by_email("cyrille@stuff.com")
		assert_not_nil(new_user)
		assert_equal "(027)8987987", new_user.mobile
		assert_equal wellington, new_user.region
    # #1 tab for hypnotherapy
    assert_equal 1, new_user.tabs.size
	end
	
  def test_create_full_membership_direct_debit
		old_size = User.all.size
		district = districts(:wellington_wellington_city)
		wellington = regions(:wellington)
    hypnotherapy = subcategories(:hypnotherapy)
		post :create, :user => {:email => "cyrille@stuff.com", :password => "testtest23",
      :password_confirmation => "testtest23", :professional => true, :district_id => district.id, :mobile_prefix => "027",
      :accept_terms => "1", :mobile_suffix => "8987987", :first_name => "Cyrille", :last_name => "Stuff", :membership_type => "full_member", :subcategory1_id => hypnotherapy.id   },
      :commit => "Pay by direct debit" 
    assert_not_nil assigns(:payment)
    assert_redirected_to :controller => "payments", :action => "edit_debit",  :id => assigns(:payment).id
		assert_not_nil assigns(:user)
    # # 	puts assigns(:user).errors.inspect
		assert_equal 0, assigns(:user).errors.size
		assert_equal old_size+1, User.all.size
		new_user = User.find_by_email("cyrille@stuff.com")
		assert_not_nil(new_user)
		assert_equal "(027)8987987", new_user.mobile
		assert_equal wellington, new_user.region
    # #1 tab for hypnotherapy
    assert_equal 1, new_user.tabs.size
	end
	
  def test_create_full_membership_with_error
    hypnotherapy = subcategories(:hypnotherapy)
		post :create, :user => {:email => "cyrille@stuff.com", :password => "testtest23",
      :password_confirmation => "testtest23", :professional => true, :district_id => "", :mobile_prefix => "027",
      :accept_terms => "1", :mobile_suffix => "8987987", :first_name => "Cyrille", :last_name => "Stuff",
      :membership_type => "full_member", :subcategory1_id => hypnotherapy.id   }
    assert_template "new"
   # puts @response.body
    assert_select "h2", :text => "Sign up for full membership" 
    assert_select "option[value=#{hypnotherapy.id}][selected=selected]"
		assert_not_nil assigns(:user)
    # # 	puts assigns(:user).errors.inspect
		assert_equal 1, assigns(:user).errors.size
	end
end
