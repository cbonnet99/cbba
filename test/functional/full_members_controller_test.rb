require File.dirname(__FILE__) + '/../test_helper'

class FullMembersControllerTest < ActionController::TestCase
  fixtures :all
  
  test "valid response" do
    get :index
#    puts @response.body
    assert_match %r{Cyrille Bonnet}, @response.body
  end
end
