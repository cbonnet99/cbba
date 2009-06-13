require File.dirname(__FILE__) + '/../test_helper'

class FullMembersControllerTest < ActionController::TestCase
  fixtures :all
  
  test "valid response" do
    cyrille = users(:cyrille)
    suspended_user1 = users(:suspended_user1)
    get :index
    assert assigns(:members).include?(cyrille)
    assert !assigns(:members).include?(suspended_user1)
#    puts @response.body
    assert_match %r{Cyrille Bonnet}, @response.body
  end
end
