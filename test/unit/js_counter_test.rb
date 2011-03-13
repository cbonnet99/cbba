require File.dirname(__FILE__) + '/../test_helper'

class JsCounterTest < ActiveSupport::TestCase
  def test_set_subcats
    nz = countries(:nz)
    JsCounter.set_subcats(nz, 12345435)
    assert_equal 12345435, JsCounter.subcats_value(nz)
    JsCounter.set_subcats(nz, 12345437)
    assert_equal 12345437, JsCounter.subcats_value(nz)
  end
end
