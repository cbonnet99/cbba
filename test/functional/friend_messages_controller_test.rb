require File.dirname(__FILE__) + '/../test_helper'

class FriendMessagesControllerTest < ActionController::TestCase
  def test_new
    get :new
    assert_response :success
  end
  def test_new_logged_in
    get :new, {}, {:user_id => users(:cyrille).id }
    assert_response :success
    assert_no_match %r{Your email address}, @response.body
  end
  def test_new_with_initial_values
    get :new, {:subject => "subj", :body => "body" }
    assert_response :success
    assert_not_nil assigns(:message)
    assert_equal "subj", assigns(:message).subject
    assert_equal "body", assigns(:message).body
  end
  
  def test_create_errors
    ActionMailer::Base.deliveries = []
    post :create, { }
    assert_response :success
    assert_not_nil assigns(:message)
    assert !assigns(:message).errors.blank?
    assert_not_nil flash[:error]
    assert_nil flash[:notice]
    assert_equal 0, ActionMailer::Base.deliveries.size
  end
  def test_create
    ActionMailer::Base.deliveries = []
    
    post :create, {:friend_message => {:from_email  => "dfsfdsf@test.com", :to_email => "dsdgfg@test.com", :subject => "An article", :body => "Here it is"} }
    assert_redirected_to root_url
    assert_not_nil assigns(:message)
    assert assigns(:message).errors.blank?
    assert_nil flash[:error]
    assert_not_nil flash[:notice]
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not_nil assigns(:message).sent_at
  end
  def test_create_logged_in
    ActionMailer::Base.deliveries = []
    post :create, {:friend_message => {:to_email => "dsdgfg@test.com", :subject => "An article", :body => "Here it is"} }, {:user_id => users(:cyrille).id }
    assert_redirected_to root_url
    assert_not_nil assigns(:message)
    assert assigns(:message).errors.blank?
    assert_nil flash[:error]
    assert_not_nil flash[:notice]
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not_nil assigns(:message).sent_at
  end
  def test_create_with_return_url
    ActionMailer::Base.deliveries = []
    article = Factory(:article)
    post :create, {:return_to => article_url(article), :friend_message => {:from_email  => "dfsfdsf@test.com", :to_email => "dsdgfg@test.com", :subject => "An article", :body => "Here it is"} }
    assert_redirected_to article_url(article)
    assert_not_nil assigns(:message)
    assert assigns(:message).errors.blank?
    assert_nil flash[:error]
    assert_not_nil flash[:notice]
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not_nil assigns(:message).sent_at
  end
end
