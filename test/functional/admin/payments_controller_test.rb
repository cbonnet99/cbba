require File.dirname(__FILE__) + '/../../test_helper'

class Admin::PaymentsControllerTest < ActionController::TestCase

  def test_index
    get :index, {}, {:user_id => users(:cyrille).id }
    assert !assigns(:payments).blank?
  end

  def test_mark_as_paid
    order = Order.create(:whole_package => true, :user => users(:cyrille))
    assert_not_nil order.payment
    assert_equal "pending", order.payment.status
    post :mark_as_paid, {:id => order.payment.id }, {:user_id => users(:cyrille).id }
    # assert_response :success
    order.payment.reload
    assert_equal "completed", order.payment.status
    order.reload
    assert_equal "paid", order.state
  end
end
