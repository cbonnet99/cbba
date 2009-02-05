require File.dirname(__FILE__) + '/../test_helper'

class PaymentTest < ActiveSupport::TestCase
  fixtures :all
  include ApplicationHelper

  def test_amount_view
    assert_equal "$101.45", amount_view(10145)
  end

  def test_pending
    cyrille = users(:cyrille)
    assert_equal 1, cyrille.payments.pending.size
  end
end
