require File.dirname(__FILE__) + '/../test_helper'

class PaymentsControllerTest < ActionController::TestCase
  def test_should_get_index
    cyrille = users(:cyrille)
    get :index
    assert_redirected_to new_session_path
    get :index, {}, {:user_id => cyrille.id }
    assert_response :success
    assert_not_nil assigns(:payments)
  end

  def test_should_get_new
    cyrille = users(:cyrille)
    get :new, {}, {:user_id => cyrille.id }
    assert_response :success
  end

  def test_should_create_payment
    assert_difference('Payment.count') do
      post :create, :payment => { }
    end

    assert_redirected_to payment_path(assigns(:payment))
  end

  def test_should_show_payment
    cyrille = users(:cyrille)
    get :show, :id => payments(:one).id
    assert_redirected_to new_session_path
    get :show, {:id => payments(:one).id}, {:user_id => cyrille.id }
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => payments(:one).id
    assert_response :success
  end

  def test_should_update_payment
    put :update, :id => payments(:one).id, :payment => { }
    assert_redirected_to payment_path(assigns(:payment))
  end

  def test_should_destroy_payment
    assert_difference('Payment.count', -1) do
      delete :destroy, :id => payments(:one).id
    end

    assert_redirected_to payments_path
  end
end
