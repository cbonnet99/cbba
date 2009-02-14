require File.dirname(__FILE__) + '/../test_helper'

class SubcategoriesControllerTest < ActionController::TestCase
  fixtures :all

  def test_index_js
    get :index, :format => "js"
    assert_response :success
  end
end
