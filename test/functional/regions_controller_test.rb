require File.dirname(__FILE__) + '/../test_helper'

class RegionsControllerTest < ActionController::TestCase
  def test_districts
		wellington = regions(:wellington)
    get :districts, :id => wellington.id, :format => "js"
#		puts @response.body
		assert_match /\{optionValue:(\d)+, optionDisplay: \"Wellington City\"\}/, @response.body
		assert_valid_json(@response.body)
  end
end
