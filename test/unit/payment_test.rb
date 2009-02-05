require File.dirname(__FILE__) + '/../test_helper'

class PaymentTest < ActiveSupport::TestCase
  fixtures :all
  include ApplicationHelper

  def test_amount_view
    assert_equal "$101.45", amount_view(10145)
  end
end
