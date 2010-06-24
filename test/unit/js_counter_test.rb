require File.dirname(__FILE__) + '/../test_helper'

class JsCounterTest < ActiveSupport::TestCase
  def test_set_subcats
    JsCounter.set_subcats(12345435)
    assert_equal 12345435, JsCounter.subcats_value
    JsCounter.set_subcats(12345437)
    assert_equal 12345437, JsCounter.subcats_value
  end
end
