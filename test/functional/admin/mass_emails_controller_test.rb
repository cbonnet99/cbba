require File.dirname(__FILE__) + '/../../test_helper'

class Admin::MassEmailsControllerTest < ActionController::TestCase
  fixtures :all

  def test_show
    cyrille = users(:cyrille)
    mass_email = Factory(:mass_email, :test_sent_at => nil)
    get :show, {:id => mass_email.id}, {:user_id => cyrille.id}
    assert_response :success
    
    mass_email = Factory(:mass_email, :test_sent_at => Time.now)
    get :show, {:id => mass_email.id}, {:user_id => cyrille.id}
    assert_response :success
    
    mass_email = Factory(:mass_email, :sent_at => nil)
    get :show, {:id => mass_email.id}, {:user_id => cyrille.id}
    assert_response :success

    mass_email = Factory(:mass_email, :sent_at => Time.now)
    get :show, {:id => mass_email.id}, {:user_id => cyrille.id}
    assert_response :success
  end

  def test_create_and_send_test
    cyrille = users(:cyrille)
    newsletter = Factory(:newsletter, :author => cyrille)
    old_size = MassEmail.all.size
    post :create_and_send_test, {:newsletter_id => newsletter.id }, {:user_id => cyrille.id}
    assert_redirected_to admin_newsletters_url
    assert_equal old_size+1, MassEmail.all.size
    last_mass_email = MassEmail.last
    assert_equal newsletter.id, last_mass_email.newsletter_id
    assert_not_nil last_mass_email.test_sent_at?
    assert_not_nil last_mass_email.test_sent_to_id
  end

  def test_copy
    test_email = mass_emails(:test_email)
    post :copy, {:id => test_email.id}, {:user_id => users(:cyrille).id }
    assert_response :success
    assert_not_nil assigns(:new_mass_email)
    assert_equal test_email.subject, assigns(:new_mass_email).subject
    assert_equal test_email.body, assigns(:new_mass_email).body
  end

  def test_create
    post :create, {:mass_email => {:subject => "Test", :body => "This is cool", :email_type => "Normal"  }}, {:user_id => users(:cyrille).id }
    assert_equal "Successfully created email.", flash[:notice]
  end

  def test_create_biz
    post :create, {:mass_email => {:subject => "Test", :body => "This is cool", :email_type => "Business newsletter"  }}, {:user_id => users(:cyrille).id }
    assert_equal "Successfully created email.", flash[:notice]
    assert_equal "Full members", assigns(:mass_email).recipients
  end

  def test_create_public_newsletter
    post :create, {:mass_email => {:subject => "Test", :newsletter_id => newsletters(:may_published), :email_type => "Public newsletter"  }}, {:user_id => users(:cyrille).id }
    assert_equal "Successfully created email.", flash[:notice]
    assert_equal "All subscribers", assigns(:mass_email).recipients
  end

  def test_send_newsletter
    old_size = UserEmail.all.size
    
    email_public_newsletter = mass_emails(:email_public_newsletter)
    post :update, {:send => "Send", :id => email_public_newsletter.id, :mass_email => {:recipients => "All subscribers" }, :send => true, :return_to => admin_newsletters_url }, {:user_id => users(:cyrille).id }
    assert_redirected_to admin_newsletters_url
    email_public_newsletter.reload
    assert_equal "All subscribers", email_public_newsletter.recipients
    assert_not_nil email_public_newsletter.sent_at
    assert_not_nil email_public_newsletter.sent_by_id
    assert_equal old_size+User.active.wants_newsletter.size+Contact.active.wants_newsletter.size, UserEmail.all.size
    UserEmail.check_and_send_mass_emails
  end

  def test_update_newsletter
    old_size = UserEmail.all.size
    
    email_public_newsletter = mass_emails(:email_public_newsletter)
    post :update, {:send => "Send", :id => email_public_newsletter.id, :mass_email => {:recipients => "Full members" }  }, {:user_id => users(:cyrille).id }
    assert_redirected_to :action => "show"
    email_public_newsletter.reload
    assert_equal "Full members", email_public_newsletter.recipients
    assert_not_nil email_public_newsletter.sent_at

    assert_equal old_size+User.active.full_members.size, UserEmail.all.size
    UserEmail.check_and_send_mass_emails
  end

  def test_update
    old_size = UserEmail.all.size
    
    test_email = mass_emails(:test_email)
    post :update, {:send => "Send", :id => test_email.id, :mass_email => {:recipients => "Full members" }  }, {:user_id => users(:cyrille).id }
    assert_redirected_to :action => "show"
    test_email.reload
    assert_equal "Full members", test_email.recipients
    assert_not_nil test_email.sent_at

    assert_equal old_size+User.active.full_members.size, UserEmail.all.size
  end

  def test_update_with_errors
    old_size = UserEmail.all.size
    
    test_email = mass_emails(:test_email)
    post :update, {:send => "Send", :id => test_email.id, :mass_email => {:subject => "", :recipients => "Full members" }  }, {:user_id => users(:cyrille).id }
    assert_response :success
    assert_template 'edit'
  end

  def test_update2
    old_size = UserEmail.all.size
    
    test_email = mass_emails(:test_email)
    post :update, {:send => "Send", :id => test_email.id, :mass_email => {:recipients => "Full members"}  }, {:user_id => users(:cyrille).id }
    assert_redirected_to :action => "show"
    test_email.reload
    assert_equal "Full members", test_email.recipients
    assert_not_nil test_email.sent_at

    assert_equal old_size+User.active.full_members.size, UserEmail.all.size
  end

  def test_edit
    get :edit, {:id => mass_emails(:test_email)}, {:user_id => users(:cyrille).id }
    assert_response :success
  end

  def test_index
    get :index, {}, {:user_id => users(:cyrille).id }
    assert_response :success
  end

  def test_send_test
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    post :send_test, {:id => mass_emails(:simple).id}, {:user_id => users(:cyrille).id }
    assert_redirected_to :action => "show"
    assert_equal "The test email was sent", flash[:notice]
    assert_equal 1, ActionMailer::Base.deliveries.size
    email = ActionMailer::Base.deliveries.first
    assert_equal mass_emails(:simple).body, email.body
    assert_equal [users(:cyrille).email], email.to
  end

  def test_send_test2
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    post :send_test, {:id => mass_emails(:test_email).id}, {:user_id => users(:cyrille).id }
    assert_redirected_to :action => "show"
    assert_equal "The test email was sent", flash[:notice]
    assert_equal 1, ActionMailer::Base.deliveries.size
    email = ActionMailer::Base.deliveries.first
    assert_match Regexp.new(users(:cyrille).first_name), email.body
    assert_match Regexp.new(users(:cyrille).business_name), email.body
    assert_match Regexp.new(users(:cyrille).email), email.body
  end
end
