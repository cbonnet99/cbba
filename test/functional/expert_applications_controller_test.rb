require File.dirname(__FILE__) + '/../test_helper'

class ExpertApplicationsControllerTest < ActionController::TestCase
  fixtures :all
  test "new should rspond" do
    get :new, {}, {:user_id => users(:cyrille).id }
    assert_response :success
  end
  test "create should work" do
    post :create, {}, {:user_id => users(:cyrille).id }
    assert_response :success
  end
end
