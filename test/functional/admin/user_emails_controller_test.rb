require File.dirname(__FILE__) + '/../../test_helper'

class Admin::UserEmailsControllerTest < ActionController::TestCase
  def test_index
    get :index, {}, {:user_id => users(:cyrille).id }
    assert_response :success
  end
end
