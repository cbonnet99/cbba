require File.dirname(__FILE__) + '/../test_helper'

class SubcategoriesControllerTest < ActionController::TestCase
  include ApplicationHelper
  fixtures :all

  def test_index_js
    get :index, :format => "js"
    assert_response :success
  end
  
  def test_region
    plenty = regions(:plenty)
    get :region, {:region_name => dasherize(plenty.name),
      :category_name => dasherize(categories(:courses).name),
      :subcategory_name => dasherize(subcategories(:yoga).name)}
    assert_response:success
    assert_equal plenty, assigns(:region)
  end
  
end
