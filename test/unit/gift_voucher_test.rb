require File.dirname(__FILE__) + '/../test_helper'

class GiftVoucherTest < ActiveSupport::TestCase
  fixtures :all
  
  def test_count_published_gift_vouchers
    assert_equal 1, GiftVoucher.count_published_gift_vouchers
  end
end
