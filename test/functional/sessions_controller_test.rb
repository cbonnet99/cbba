require File.dirname(__FILE__) + '/../test_helper'

class SessionsControllerTest < ActionController::TestCase
	fixtures :all

  include ApplicationHelper

  def test_create
    cyrille = users(:cyrille)
    post :create, :email => cyrille.email, :password => "monkey"
    assert_redirected_to expanded_user_path(cyrille)
    assert_equal "Logged in successfully", flash[:notice]
    cyrille.reload
    assert !cyrille.free_listing?
  end
  def test_create_pending
    pending_user = users(:pending_user)
    pending_user_payment = payments(:pending_user_payment)
    post :create, :email => pending_user.email, :password => "monkey"
    assert_redirected_to edit_payment_path(pending_user_payment)
    assert_equal "You need to complete your payment", flash[:warning]
  end
end