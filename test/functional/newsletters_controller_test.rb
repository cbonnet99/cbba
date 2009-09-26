require File.dirname(__FILE__) + '/../test_helper'

class NewslettersControllerTest < ActionController::TestCase
  def test_show
    get :show, :id => newsletters(:may_published).id
    assert_response :success
  end
end
