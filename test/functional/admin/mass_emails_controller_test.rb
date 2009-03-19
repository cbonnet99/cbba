require File.dirname(__FILE__) + '/../../test_helper'

class Admin::MassEmailsControllerTest < ActionController::TestCase
  fixtures :all
  
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
