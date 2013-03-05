require File.dirname(__FILE__) + '/../test_helper'

class CountriesControllerTest < ActionController::TestCase
  def test_districts_json
    au = countries(:au)
    get :districts, :id => au.id, :format => "json"
    
    assert_response :success
    assert_valid_json @response.body
    assert_equal 1, assigns(:districts).size 
  end

  def test_hosts_json
    get :hosts, :format => "js"
    
    assert_response :success
    assert_valid_json @response.body
  end
end
