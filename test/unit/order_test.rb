require File.dirname(__FILE__) + '/../test_helper'

class OrderTest < ActiveSupport::TestCase
  fixtures :all
  def test_compute_amount
    order = Factory(:order, :photo => true, :highlighted => false,  :special_offers => "", :gift_vouchers => 2)
    assert_equal 6000, order.compute_amount
    order = Factory(:order, :photo => true, :highlighted => true,  :special_offers => 1, :gift_vouchers => 2)
    assert_equal 10500, order.compute_amount
    order = Factory(:order, :whole_package => true)
    assert_equal 7500, order.compute_amount
    order = Factory(:order, :whole_package => true, :photo => true, :highlighted => true,  :special_offers => 1, :gift_vouchers => 2)
    assert_equal 7500, order.compute_amount, "When whole package is selected, all other options should be ignored"
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
end
