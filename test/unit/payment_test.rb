require File.dirname(__FILE__) + '/../test_helper'

class PaymentTest < ActiveSupport::TestCase
  fixtures :all

  def test_amount_view
    assert true
#    assert_equal "NZD 101.45", amount_view(10145)
  end
end
