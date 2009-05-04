require File.dirname(__FILE__) + '/../../test_helper'

class Admin::PaymentsControllerTest < ActionController::TestCase

  def test_index
    get :index, {}, {:user_id => users(:cyrille).id }
    assert !assigns(:payments).blank?
  end

  def test_mark_as_paid
    pending = payments(:pending_user_payment)
    assert_equal "pending", pending.status
    post :mark_as_paid, {:id => pending.id }, {:user_id => users(:cyrille).id }
    # assert_response :success
    pending.reload
    assert_equal "completed", pending.status
  end
end
