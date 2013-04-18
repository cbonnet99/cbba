require File.dirname(__FILE__) + '/../test_helper'

class CountriesControllerTest < ActionController::TestCase

  def test_regions_json
    au = countries(:au)
    get :regions, :id => au.id, :format => "json"
    
    assert_response :success
    assert_valid_json @response.body
    assert_equal 2, assigns(:regions).size 
  end

  def test_hosts_json
    get :hosts, :format => "js"
    
    assert_response :success
    assert_valid_json @response.body
  end
end
