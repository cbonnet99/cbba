require File.dirname(__FILE__) + '/../../test_helper'

class Admin::ResidentExpertsControllerTest < ActionController::TestCase
  def test_index
    get :index, {}, {:user_id => users(:cyrille).id }
    assert_response :success
  end
  def test_index_for_subcategory
    get :index_for_subcategory, {:id => subcategories(:yoga).id }, {:user_id => users(:cyrille).id }
    assert_response :success
  end
end
