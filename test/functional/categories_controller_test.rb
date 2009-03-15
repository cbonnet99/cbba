require File.dirname(__FILE__) + '/../test_helper'

class CategoriesControllerTest < ActionController::TestCase

	fixtures :all

  def test_region
    get :region, {:region_name => "wellington", :category_name => "practitioners" }
    assert_response :success
  end

  def test_subcategories_js
		practitioners = categories(:practitioners)
		get :subcategories, :id => practitioners.id, :format => "js"
		assert_match /\{optionValue:(\d)+, optionDisplay: \"Hypnotherapy\"\}/, @response.body
		assert_valid_json(@response.body)
  end
end
