require File.dirname(__FILE__) + '/../test_helper'

class FullMembersControllerTest < ActionController::TestCase
  fixtures :all
  
  test "valid response" do
    active_user = Factory(:user)
    active_user.user_profile.publish!
    inactive_user = Factory(:user, :state => "inactive")
    unconfirmed_user = Factory(:user, :state => "unconfirmed")
    
    get :index, :country_code => "nz"
    
    assert assigns(:members).include?(active_user)
    assert !assigns(:members).include?(inactive_user)
    assert !assigns(:members).include?(unconfirmed_user)
#    puts @response.body
    assert_match Regexp.new(active_user.name), @response.body
  end
end
