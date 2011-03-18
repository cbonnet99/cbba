require File.dirname(__FILE__) + '/../test_helper'

class GiftVoucherTest < ActiveSupport::TestCase
  fixtures :all
  
  def test_count_published_gift_vouchers
    nz = countries(:nz)
    assert_equal 4, GiftVoucher.count_published_gift_vouchers(nz)
  end
end
