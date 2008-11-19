require File.dirname(__FILE__) + '/../test_helper'

class CategoriesControllerTest < ActionController::TestCase

	fixtures :all

  def test_subcategories_js
		practicioners = categories(:practicioners)
		get :subcategories, :id => practicioners.id, :format => "js"
		assert_match /\{optionValue:(\d)+, optionDisplay: \"Hypnotherapy\"\}/, @response.body
		assert_valid_json(@response.body)
  end
end
