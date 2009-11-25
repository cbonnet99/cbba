require File.dirname(__FILE__) + '/../test_helper'

class OrdersControllerTest < ActionController::TestCase
  fixtures :all
  
  def test_create
    cyrille = users(:cyrille)
    old_size = Order.all.size
    assert_equal 0, cyrille.orders.pending.size
    assert_equal 0, cyrille.orders.size
    old_payment_size = Payment.all.size
    post :create, {:order => {:photo => true, :special_offers => 1 } }, {:user_id => cyrille.id }
    assert_not_nil assigns(:order)
    assert_not_nil assigns(:order).payment
    assert assigns(:order).photo?
    assert_equal 1, assigns(:order).special_offers
    cyrille.reload
    assert_equal old_size+1, Order.all.size
    assert_equal 1, cyrille.orders.size
    assert_equal 1, cyrille.orders.pending.size
    assert_equal old_payment_size+1, Payment.all.size
    assert_not_nil cyrille.orders.pending.first.payment
    assert_redirected_to payment_action_with_id_url(assigns(:order).payment.id, :action => "edit" )
  end
  def test_update
    cyrille = users(:cyrille)
    
    order = cyrille.orders.create(:state => "pending", :photo => true, :special_offers => 1 )
    first_order_amount = order.compute_amount
    first_payment_amount = order.payment.amount
    
    post :update, {:id => order.id, :order => {:photo => true, :highlighted => true, :special_offers => 1} }, {:user_id => cyrille.id }
    assert assigns(:order).highlighted?
    assert first_order_amount < assigns(:order).compute_amount, "Order amount should have been updated and should be bigger than #{first_order_amount} (but it was #{assigns(:order).compute_amount})"
    assert first_payment_amount < assigns(:order).payment.amount, "Payment amount should have been updated and should be bigger than #{first_payment_amount} (but it was #{assigns(:order).payment.amount})"
    
  end
end
