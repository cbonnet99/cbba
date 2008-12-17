require File.dirname(__FILE__) + '/../test_helper'

class SessionsControllerTest < ActionController::TestCase
	fixtures :all

  def test_create
    cyrille = users(:cyrille)
    post :create, :email => cyrille.email, :password => "monkey"
    assert_redirected_to user_path(cyrille)
    assert_equal "Logged in successfully", flash[:notice]
    cyrille.reload
    assert !cyrille.free_listing?
  end
end