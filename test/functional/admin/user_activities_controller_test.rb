require File.dirname(__FILE__) + '/../../test_helper'

class Admin::UserActivitiesControllerTest < ActionController::TestCase
  def test_index
    get :index, {}, {:user_id => users(:cyrille).id }
    assert_response :success
  end
  def test_show
    get :show, {:id => users(:norma) }, {:user_id => users(:cyrille).id }
    assert_response :success
    assert !assigns(:activities).blank?
    assert_equal 2, assigns(:activities).size
  end
end
