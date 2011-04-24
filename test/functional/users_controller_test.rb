require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase
	fixtures :all
	include ApplicationHelper

  # def test_destroy_unpublished
  #   user = Factory(:user, :unsubscribe_token => "bla")
  #   user_email = user.email
  #   assert user.user_profile.draft?
  #   post :destroy, {:email => user.email, :token => user.unsubscribe_token}
  #   assert_response :success
  #   assert_nil flash[:error], "Flash: #{flash.inspect}"
  #   assert_nil User.find_by_email(user_email)
  # end

  def test_warning_deactivate
    user = Factory(:user, :paid_special_offers => 1, :paid_gift_vouchers => 1)
    user.user_profile.publish!
    so = Factory(:special_offer, :author => user )
    so.publish!
    assert so.published?
    gv = Factory(:gift_voucher, :author => user )
    gv.publish!
    assert gv.published?
    
    post :deactivate, {}, {:user_id => user.id}
    
    assert_redirected_to user_warning_deactivate_url
    user.reload
    assert_not_nil user
    assert user.active?
    assert user.published?
    
    so.reload
    assert so.published?
    gv.reload
    assert gv.published?
  end

  def test_deactivate
    user = Factory(:user)
    user.user_profile.publish!
    
    post :deactivate, {}, {:user_id => user.id}
    
    assert_redirected_to root_url
    user.reload
    assert_not_nil user
    assert !user.active?
    assert !user.published?
    
    post :reactivate, {}, {:user_id => user.id }
    assert_redirected_to expanded_user_url(user)
    user.reload
    assert_not_nil user
    assert user.active?
    assert user.published?
  end

  def test_deactivate_confirm
    user = Factory(:user, :paid_special_offers => 1, :paid_gift_vouchers => 1)
    user.user_profile.publish!
    so = Factory(:special_offer, :author => user )
    so.publish!
    assert so.published?
    gv = Factory(:gift_voucher, :author => user )
    gv.publish!
    assert gv.published?
    
    post :deactivate, {:confirm => "true" }, {:user_id => user.id}
    
    assert_redirected_to root_url
    user.reload
    assert_not_nil user
    assert !user.active?
    assert !user.published?
    
    so.reload
    assert !so.published?
    gv.reload
    assert !gv.published?
    
    user.subcategories_users.reload
    assert user.subcategories_users.reject{|su| su.points==0}.blank?, "user.subcategories_users: #{user.subcategories_users.inspect}"
  end

  def test_unsubscribe_unpublished_reminder
    user = Factory(:user, :notify_unpublished => true, :unsubscribe_token => "bla")
    assert user.notify_unpublished?
    post :unsubscribe_unpublished_reminder, {:email => user.email, :unsubscribe_token => user.unsubscribe_token}
    assert_response :success
    assert_nil flash[:error], "Flash: #{flash.inspect}"
    user.reload
    assert !user.notify_unpublished?
  end

  def test_unsubscribe_unpublished_reminder_invalid_token
    user = Factory(:user, :notify_unpublished => true, :unsubscribe_token => "bla")
    post :unsubscribe_unpublished_reminder, {:email => user.email, :unsubscribe_token => "ahaha"}
    assert_response :success
    assert_not_nil flash[:error], "Flash: #{flash.inspect}"
    user.reload
    assert user.notify_unpublished?
  end

  def test_refer
    get :refer, {}, {:user_id => users(:sgardiner) }
    assert_response :success
    assert_select "input[name=emails]"
    assert_select "textarea[name=comment]"
  end
  
  def test_send_referrals
    sgardiner = users(:sgardiner)
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    
    post :send_referrals, {:emails => "joe@test.com jane@yahoo.fr bob@gmail.com", :comment => "This is cool" }, {:user_id => sgardiner }
    assert_redirected_to expanded_user_url(sgardiner)
    assert_nil flash[:error], "Flash: #{flash.inspect}"
    assert_not_nil flash[:notice], "Flash: #{flash.inspect}"
    assert_equal "Thank you. 3 emails were sent", flash[:notice]
    assert_equal 3, ActionMailer::Base.deliveries.size, "3 emails should have been sent for the 3 email addresses"
  end

  def test_unsubscribe
    user = Factory(:user, :receive_newsletter => true, :unsubscribe_token => "3872643uygyyt34")
    assert user.receive_newsletter?
    get :unsubscribe, :token => user.unsubscribe_token, :slug => user.slug 
    assert_response :success
    assert_nil flash[:error], "Flash: #{flash.inspect}"
    assert_template 'unsubscribe_success'
    user.reload
    assert !user.receive_newsletter?
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

  def test_message_user_not_found
    get :message, :slug => "BLA"
    assert_not_nil flash[:error]
    assert_redirected_to root_url
  end

  def test_stats
    get :stats, {}, {:user_id => users(:cyrille).id }
    assert_response :success
    assert_match %r{([0-9])+ visit(s?) to your profile page}, @response.body
    assert_match %r{([0-9])+ email enquir(y|ies) via BeAmazing}, @response.body
    assert_match %r{([0-9])+ click(s?) through to your website}, @response.body
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

  def test_index
    get :index
    assert_response :success
    assert !assigns(:full_members).blank?
  end

  def test_edit
    cyrille = users(:cyrille)
    get :edit, {}, {:user_id => cyrille.id }
    assert_response :success
    assert_select "select#user_subcategory1_id", :count => 0
  end

  def test_new
    get :new
    assert_response :success
    assert_select "select#user_subcategory1_id"
    assert_select "select#user_district_id > option", :text => "Auckland Region - Auckland City"
    assert_select "select#user_district_id > option", :text => "New South Wales - Sydney", :count => 0
  end

  def test_new_au
    get :new, :country_code => "au" 
    assert_response :success
    assert_select "select#user_district_id > option", :text => "Auckland Region - Auckland City", :count => 0  
    assert_select "select#user_district_id > option", :text => "New South Wales - Sydney"    
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

		assert ActionMailer::Base.deliveries.size > 1, "an email should be sent to reviewers (in addition to the one to the user)"
		assert_equal 1, ActionMailer::Base.deliveries.reject{|email| !email.to.include?(sgardiner.email)}.size, "an email should be sent to the user"
		
	end
  
	def test_publish_with_unedited_tabs
	  hypnotherapy = subcategories(:hypnotherapy)
	  district = District.first
	  nz = Country.find_by_country_code("nz")
	  user = User.create(:country => nz, :email => "cyrille@stuff.com", :password => "testtest23", :first_name => "Cyrille", :last_name => "Stuff",
      :password_confirmation => "testtest23", :district_id => district.id, :membership_type => "free_listing",
      :accept_terms => "1", :subcategory1_id => hypnotherapy.id)
    assert_equal 1, user.tabs.size
    tab = user.tabs.first
    assert_match /delete this text/, tab.content1_with
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

		post :publish, {}, {:user_id => user.id}
    assert_redirected_to expanded_user_url(user)
		assert_equal "Your tab #{user.tabs.first.title} is incomplete: please enter information or delete the tab", flash[:error]

		user.user_profile.reload
		assert_nil user.user_profile.published_at

		assert_equal 0, ActionMailer::Base.deliveries.size
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

  def test_show_offers_with_so_to_approve
    cyrille = users(:cyrille)
    auckland = regions(:auckland)
    coaches = categories(:coaches)
    
    so = Factory(:special_offer, :author => cyrille )    
    so.publish!
    
    get :show, {:name => cyrille.slug, :region => auckland.slug, :main_expertise_slug => coaches.slug, :selected_tab_id => "offers" }, {:user_id => cyrille.id }
    assert_response :success
  end

  
  def test_show
    old_size = UserEvent.all.size
    rmoore = users(:rmoore)
    cyrille = users(:cyrille)
    auckland = regions(:auckland)
    coaches = categories(:coaches)
    
    assert !rmoore.paid_photo?
    
    get :show, {:name => rmoore.slug, :region => auckland.slug, :main_expertise_slug => coaches.slug}, {:user_id => rmoore.id }
    # #visits to own profile should not be recorded
    assert_equal old_size, UserEvent.all.size
    get :show, {:name => cyrille.slug, :region => auckland.slug, :main_expertise_slug => coaches.slug}, {:user_id => rmoore.id }
    assert_equal old_size+1, UserEvent.all.size
    assert_select "img[src*=nophoto.gif]"
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
    assert_select "a", :text => "Upload your picture here"
  end

  def test_show_not_own_profile
    cyrille = users(:cyrille)
    norma = users(:norma)
    assert cyrille.user_profile.published?
    get :show, {:name => cyrille.slug, :region => cyrille.region.slug, :main_expertise_slug => cyrille.main_expertise.slug}, {:user_id => norma.id }
    assert_response :success
    # #Cyrille's profile is already published: Unpublish button should be shown
   # puts @response.body
    assert_select "input[value=Publish]", :count => 0
    assert_select "input[value=Unpublish]", :count => 0
    #only one published article
    assert_select "a", :text => "1 article"
    
    #only one published trial session and one published gift voucher
    assert_select "a", :text => "2 offers"
  end

  def test_show_not_own_profile_admin
    cyrille = users(:cyrille)
    norma = users(:norma)
    get :show, {:name => norma.slug, :region => norma.region.slug, :main_expertise_slug => norma.main_expertise.slug}, {:user_id => cyrille.id }
    assert_response :success
    assert_select "input[value=Publish]", :count => 0
    assert_select "input[value=Unpublish]", :count => 0
    assert_select "div[class=publication-actions]", :count => 0
    
    #only one published trial session and one published gift voucher
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
    assert_select "a", :text => "Upload your picture here", :count => 0
  end

  def test_show_upload_photo
    norma = users(:norma)
    auckland = regions(:auckland)
    coaches = categories(:coaches)
    norma.paid_photo = true
    norma.save!
    norma.reload
    get :show, {:name => norma.slug, :region => auckland.slug, :main_expertise_slug => coaches.slug}, {:user_id => norma.id }
    assert_response :success
    # puts @response.body
    assert_select "a", :text => "0 articles"
    assert_select "a", :text => "3 offers"
    assert_select "a", :text => "Upload your picture here", :count => 1
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
		district = districts(:auckland_auckland_city)
		nz = countries(:nz)
    hypnotherapy = subcategories(:hypnotherapy)
		post :create, :user => {:email => "cyrille@stuff.com", :password => "testtest23", :first_name => "Cyrille", :last_name => "Stuff",
      :password_confirmation => "testtest23", :district_id => district.id, :membership_type => "free_listing",
      :accept_terms => "1", :subcategory1_id => hypnotherapy.id
      }
		assert_not_nil assigns(:user)
#    puts assigns(:user).errors.inspect
		assert_equal 0, assigns(:user).errors.size
		assert_equal old_size+1, User.all.size
		assert_equal 1, assigns(:user).tabs.size
		assert_not_nil assigns(:user).country
		assert_equal nz, assigns(:user).country
		tab = assigns(:user).tabs.first
		assert_match /delete this text/, tab.content1_with
		assert_match /delete this text/, tab.content2_benefits
		assert_match /delete this text/, tab.content3_training
		assert_match /delete this text/, tab.content4_about
		assert_match /delete this text/, tab.content
	end

  def test_create_au
		old_size = User.all.size
		district = districts(:new_south_wales_sydney)
		au = countries(:au)
    hypnotherapy = subcategories(:hypnotherapy)
		post :create, :user => {:email => "cyrille@stuff.com", :password => "testtest23", :first_name => "Cyrille", :last_name => "Stuff",
      :password_confirmation => "testtest23", :district_id => district.id, :membership_type => "full_membership",
      :accept_terms => "1", :subcategory1_id => hypnotherapy.id
      }
		assert_not_nil assigns(:user)
		assert_equal 0, assigns(:user).errors.size, "Errors were: #{assigns(:user).errors.full_messages.to_sentence}"
		assert_equal old_size+1, User.all.size
		assert_equal 1, assigns(:user).tabs.size
		assert_not_nil assigns(:user).country
		assert_equal au, assigns(:user).country
	end

  def test_create_with_capitals_in_email
		old_size = User.all.size
		district = District.first
    hypnotherapy = subcategories(:hypnotherapy)
		post :create, :user => {:email => "CYrille@stuff.com", :password => "testtest23", :first_name => "Cyrille", :last_name => "Stuff",
      :password_confirmation => "testtest23", :district_id => district.id, :membership_type => "free_listing",
      :accept_terms => "1", :subcategory1_id => hypnotherapy.id
      }
		assert_not_nil assigns(:user)
#    puts assigns(:user).errors.inspect
		assert_equal 0, assigns(:user).errors.size
		assert_equal old_size+1, User.all.size
		assert_equal "cyrille@stuff.com", assigns(:user).email
	end

  def test_create_with_same_name
		district = District.first
    hypnotherapy = subcategories(:hypnotherapy)
		post :create, :user => {:email => "cyrille@stuff.com", :password => "testtest23", :first_name => "Cyrille", :last_name => "Bonnet",
      :password_confirmation => "testtest23", :district_id => district.id, :membership_type => "free_listing",
      :accept_terms => "1", :subcategory1_id => hypnotherapy.id, :business_name => "Bioboy Inc", :professional => true,
      }
		assert_not_nil assigns(:user)
    # puts assigns(:user).errors.inspect
		assert_equal 1, assigns(:user).errors.size
	end
	
  def test_create_with_similar_name_with_accent
		district = District.first
    hypnotherapy = subcategories(:hypnotherapy)
		post :create, :user => {:email => "cyrille@stuff.com", :password => "testtest23", :first_name => "Cyrillé", :last_name => "Bonnet",
      :password_confirmation => "testtest23", :district_id => district.id, :membership_type => "free_listing",
      :accept_terms => "1", :subcategory1_id => hypnotherapy.id, :business_name => "Bioboy Inc", :professional => true,
      }
		assert_not_nil assigns(:user)
    # puts assigns(:user).errors.inspect
		assert_equal 1, assigns(:user).errors.size
	end
	
  def test_create_illegal_characters_in_first_name
		district = District.first
    hypnotherapy = subcategories(:hypnotherapy)
		post :create, :user => {:email => "cyrille@stuff.com", :password => "testtest23", :first_name => "Cyrille A.", :last_name => "Bonnet",
      :password_confirmation => "testtest23", :district_id => district.id, :membership_type => "free_listing",
      :accept_terms => "1", :subcategory1_id => hypnotherapy.id, :business_name => "Bioboy Inc", :professional => true,
      }
		assert_not_nil assigns(:user)
    # puts assigns(:user).errors.inspect
		assert_equal 1, assigns(:user).errors.size
	end
	
  def test_create_illegal_characters_in_first_name2
		district = District.first
    hypnotherapy = subcategories(:hypnotherapy)
		post :create, :user => {:email => "cyrille@stuff.com", :password => "testtest23", :first_name => "Cyrille A/", :last_name => "Bonnet",
      :password_confirmation => "testtest23", :district_id => district.id, :membership_type => "free_listing",
      :accept_terms => "1", :subcategory1_id => hypnotherapy.id, :business_name => "Bioboy Inc", :professional => true,
      }
		assert_not_nil assigns(:user)
    # puts assigns(:user).errors.inspect
		assert_equal 1, assigns(:user).errors.size
	end
	
  def test_create_illegal_characters_in_first_name3
		district = District.first
    hypnotherapy = subcategories(:hypnotherapy)
		post :create, :user => {:email => "cyrille@stuff.com", :password => "testtest23", :first_name => "Cyrille# A", :last_name => "Bonnet",
      :password_confirmation => "testtest23", :district_id => district.id, :membership_type => "free_listing",
      :accept_terms => "1", :subcategory1_id => hypnotherapy.id, :business_name => "Bioboy Inc", :professional => true,
      }
		assert_not_nil assigns(:user)
    # puts assigns(:user).errors.inspect
		assert_equal 1, assigns(:user).errors.size
	end
	
  def test_create_illegal_characters_in_last_name
		district = District.first
    hypnotherapy = subcategories(:hypnotherapy)
		post :create, :user => {:email => "cyrille@stuff.com", :password => "testtest23", :first_name => "Cyrille", :last_name => "Boet.",
      :password_confirmation => "testtest23", :district_id => district.id, :membership_type => "free_listing",
      :accept_terms => "1", :subcategory1_id => hypnotherapy.id, :business_name => "Bioboy Inc", :professional => true,
      }
		assert_not_nil assigns(:user)
    # puts assigns(:user).errors.inspect
		assert_equal 1, assigns(:user).errors.size
	end
	
  def test_create_illegal_characters_in_last_name2
		district = District.first
    hypnotherapy = subcategories(:hypnotherapy)
		post :create, :user => {:email => "cyrille@stuff.com", :password => "testtest23", :first_name => "Cyrille", :last_name => "Bonnet#Gonnet",
      :password_confirmation => "testtest23", :district_id => district.id, :membership_type => "free_listing",
      :accept_terms => "1", :subcategory1_id => hypnotherapy.id, :business_name => "Bioboy Inc", :professional => true,
      }
		assert_not_nil assigns(:user)
    # puts assigns(:user).errors.inspect
		assert_equal 1, assigns(:user).errors.size
	end
	
  def test_create_illegal_characters_in_last_name3
		district = District.first
    hypnotherapy = subcategories(:hypnotherapy)
		post :create, :user => {:email => "cyrille@stuff.com", :password => "testtest23", :first_name => "Cyrille", :last_name => "Bonnet/G",
      :password_confirmation => "testtest23", :district_id => district.id, :membership_type => "free_listing",
      :accept_terms => "1", :subcategory1_id => hypnotherapy.id, :business_name => "Bioboy Inc", :professional => true,
      }
		assert_not_nil assigns(:user)
    # puts assigns(:user).errors.inspect
		assert_equal 1, assigns(:user).errors.size
	end

  def test_create_illegal_characters_in_biz_name
		district = District.first
    hypnotherapy = subcategories(:hypnotherapy)
		post :create, :user => {:email => "cyrille@stuff.com", :password => "testtest23", :first_name => "Cyrille", :last_name => "Boet",
      :password_confirmation => "testtest23", :district_id => district.id, :membership_type => "free_listing",
      :accept_terms => "1", :subcategory1_id => hypnotherapy.id, :business_name => "Bioboy Inc.", :professional => true,
      }
		assert_not_nil assigns(:user)
    # puts assigns(:user).errors.inspect
		assert_equal 1, assigns(:user).errors.size
	end
	
  def test_create_illegal_characters_in_biz_name2
		district = District.first
    hypnotherapy = subcategories(:hypnotherapy)
		post :create, :user => {:email => "cyrille@stuff.com", :password => "testtest23", :first_name => "Cyrille", :last_name => "Boet",
      :password_confirmation => "testtest23", :district_id => district.id, :membership_type => "free_listing",
      :accept_terms => "1", :subcategory1_id => hypnotherapy.id, :business_name => "Bioboy#Inc", :professional => true,
      }
		assert_not_nil assigns(:user)
    # puts assigns(:user).errors.inspect
		assert_equal 1, assigns(:user).errors.size
	end
	
  def test_create_illegal_characters_in_biz_name3
		district = District.first
    hypnotherapy = subcategories(:hypnotherapy)
		post :create, :user => {:email => "cyrille@stuff.com", :password => "testtest23", :first_name => "Cyrille", :last_name => "Boet",
      :password_confirmation => "testtest23", :district_id => district.id, :membership_type => "free_listing",
      :accept_terms => "1", :subcategory1_id => hypnotherapy.id, :business_name => "Bioboy /Inc", :professional => true,
      }
		assert_not_nil assigns(:user)
    # puts assigns(:user).errors.inspect
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
    assert_redirected_to new_user_url
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
    assert_nil assigns(:payment)
    assert_redirected_to user_welcome_url
    assert_not_nil assigns(:user)
    assert assigns(:user).full_member?
    assert_equal 0, assigns(:user).errors.size, "There were errors: #{assigns(:user).errors.inspect}"
    assert_equal old_size+1, User.all.size
    new_user = User.find_by_email("cyrille@stuff.com")
    assert_not_nil(new_user)
    assert_equal "(027)8987987", new_user.mobile
    assert_equal wellington, new_user.region
    assert_equal 1, new_user.tabs.size
    assert new_user.full_member?
    assert new_user.active?, "User should now be active automatically"
  end
	
  #   def test_create_full_membership_direct_debit
  #   old_size = User.all.size
  #   district = districts(:wellington_wellington_city)
  #   wellington = regions(:wellington)
  #     hypnotherapy = subcategories(:hypnotherapy)
  #   post :create, :user => {:email => "cyrille@stuff.com", :password => "testtest23",
  #       :password_confirmation => "testtest23", :professional => true, :district_id => district.id, :mobile_prefix => "027",
  #       :accept_terms => "1", :mobile_suffix => "8987987", :first_name => "Cyrille", :last_name => "Stuff", :membership_type => "full_member", :subcategory1_id => hypnotherapy.id   },
  #       :commit => "Pay by direct debit" 
  #     assert_not_nil assigns(:payment)
  #     assert_redirected_to :controller => "payments", :action => "edit_debit",  :id => assigns(:payment).id
  #   assert_not_nil assigns(:user)
  #     # #   puts assigns(:user).errors.inspect
  #   assert_equal 0, assigns(:user).errors.size
  #   assert_equal old_size+1, User.all.size
  #   new_user = User.find_by_email("cyrille@stuff.com")
  #   assert_not_nil(new_user)
  #   assert_equal "(027)8987987", new_user.mobile
  #   assert_equal wellington, new_user.region
  #     # #1 tab for hypnotherapy
  #     assert_equal 1, new_user.tabs.size
  # end
	
  def test_create_full_membership_with_error
    hypnotherapy = subcategories(:hypnotherapy)
		post :create, :user => {:email => "cyrille@stuff.com", :password => "testtest23",
      :password_confirmation => "testtest23", :professional => true, :district_id => "", :mobile_prefix => "027",
      :accept_terms => "1", :mobile_suffix => "8987987", :first_name => "Cyrille", :last_name => "Stuff",
      :membership_type => "full_member", :subcategory1_id => hypnotherapy.id   }
    assert_template "new"
    puts @response.body
    assert_select "h2", :text => "Step 1: Your essential information" 
    assert_select "select#user_subcategory1_id"
    assert_select "select#user_subcategory1_id > option[value=#{hypnotherapy.id}][selected=selected]"
		assert_not_nil assigns(:user)
    puts assigns(:user).errors.inspect
		assert_equal 1, assigns(:user).errors.size
	end
end
