require File.dirname(__FILE__) + '/../../test_helper'

class Admin::MassEmailsControllerTest < ActionController::TestCase
  fixtures :all

  def test_update
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    test_email = mass_emails(:test_email)
    post :update, {:id => test_email.id, :mass_email => {:recipients_full_members => true }  }, {:user_id => users(:cyrille).id }
    assert_redirected_to :action => "show"
    test_email.reload
    assert test_email.recipients_full_members
    assert_not_nil test_email.sent_at

    assert_equal User.full_members.size, ActionMailer::Base.deliveries.size
  end

  def test_update2
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    test_email = mass_emails(:test_email)
    post :update, {:id => test_email.id, :mass_email => {:recipients_full_members => true, :recipients_free_users => true }  }, {:user_id => users(:cyrille).id }
    assert_redirected_to :action => "show"
    test_email.reload
    assert test_email.recipients_full_members
    assert test_email.recipients_free_users
    assert_not_nil test_email.sent_at

    assert_equal User.full_members.size+User.free_users.size, ActionMailer::Base.deliveries.size
  end

  def test_update3
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    simple = mass_emails(:simple)
    post :update, {:id => simple.id, :mass_email => {:recipients_full_members => true, :recipients_general_public => true }  }, {:user_id => users(:cyrille).id }
    assert_redirected_to :action => "show"
    simple.reload
    assert simple.recipients_full_members
    assert simple.recipients_general_public
    assert_not_nil simple.sent_at

    assert_equal User.full_members.size+Contact.all.size, ActionMailer::Base.deliveries.size
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
