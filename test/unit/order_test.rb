require File.dirname(__FILE__) + '/../test_helper'

class OrderTest < ActiveSupport::TestCase
  fixtures :all
  def test_compute_amount
    order = Factory(:order, :photo => true, :highlighted => true,  :special_offers => 2, :gift_vouchers => 2)
    assert_equal 6900, order.compute_amount
  end
  
  def test_validate
    order = Factory(:order)
    order.photo = false
    assert !order.valid?
    order = Factory(:order, :special_offers => "", :gift_vouchers  => "" )
    order.photo = false
    assert !order.valid?
    order = Factory(:order, :special_offers => "0", :gift_vouchers  => "0" )
    order.photo = false
    assert !order.valid?
  end
  
  def test_mark_as_paid
    order = Factory(:order, :photo => true)
    order.mark_as_paid!
  end
end
