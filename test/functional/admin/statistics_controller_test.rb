require File.dirname(__FILE__) + '/../../test_helper'

class Admin::StatisticsControllerTest < ActionController::TestCase
  def test_index
    get :index, {}, {:user_id => users(:cyrille).id }
    assert_response :success
  end

  def test_index_not_admin
    get :index, {}, {}
    assert_response :redirect
  end

end
