require File.dirname(__FILE__) + '/../test_helper'

class CounterTest < ActiveSupport::TestCase
  fixtures :all
  
  def test_controller_name
    assert_equal "gift_vouchers", counters(:gift_vouchers).controller_name
  end
  
  def test_action_name
    assert_equal "index_public", counters(:gift_vouchers).action_name
    assert_equal "index", counters(:full_members).action_name    
  end
end
