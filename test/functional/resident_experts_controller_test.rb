require File.dirname(__FILE__) + '/../test_helper'

class ResidentExpertsControllerTest < ActionController::TestCase
  fixtures :all
  test "valid JSON" do
    get :index, :format => "js"
#    puts @response.body
    assert_match %r{Cyrille Bonnet}, @response.body
  end
end
