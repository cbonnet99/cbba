require File.dirname(__FILE__) + '/../test_helper'

class RegionsControllerTest < ActionController::TestCase
  def test_districts
		wellington = regions(:wellington)
    get :districts, :id => wellington.id, :format => "js"
#		puts @response.body
		assert_match /\{optionValue:(\d)+, optionDisplay: \"Wellington City\"\}/, @response.body
		assert_valid_json(@response.body)
  end
  
  def test_index_js
    au = countries(:au)
    
    get :index, :format => "js", :country_code => au.country_code
    
    assert assigns(:regions).include?(regions(:new_south_wales))
    assert !assigns(:regions).include?(regions(:canterbury))
  end
end
