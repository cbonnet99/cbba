require File.dirname(__FILE__) + '/../test_helper'

class CategoriesControllerTest < ActionController::TestCase

	fixtures :all

  def test_region
    get :region, {:region_slug => regions(:wellington).slug, :category_slug => categories(:practitioners).slug }
    assert_response :success
  end
  
  def test_region_error_region
    get :region, {:region_slug => "bla", :category_slug => categories(:practitioners).slug }
    assert_redirected_to root_url
    assert "Could not find this subcategory", flash[:error]
  end
  
  def test_region_error_category
    get :region, {:region_slug => regions(:wellington).slug, :category_slug => "bla" }
    assert_redirected_to root_url
    assert "Could not find this subcategory", flash[:error]
  end
  
  def test_show
    get :show, :category_slug => categories(:practitioners).slug
    assert_response :success
  end
  
  def test_show_health
    get :show, :category_slug => categories(:health_centres).slug
    assert_response :success
  end

  def test_show_with_country_replace
    au = countries(:au)
    get :show, :category_slug => categories(:coaches).slug, :country_code => au.country_code 
    assert_response :success
    assert_select "p#description", :text => /Australia's finest coaches/
  end

  def test_show_error
    get :show, :category_slug => "bla"
    assert_redirected_to root_url
    assert "Could not find this subcategory", flash[:error]
  end

  def test_subcategories_js
		practitioners = categories(:practitioners)
		get :subcategories, :id => practitioners.id, :format => "js"
		assert_match /\{optionValue:(\d)+, optionDisplay: \"Hypnotherapy\"\}/, @response.body
		assert_valid_json(@response.body)
  end
end
