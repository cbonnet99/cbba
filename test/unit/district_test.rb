require File.dirname(__FILE__) + '/../test_helper'

class DistrictTest < ActiveSupport::TestCase
  def test_to_json
    district = Factory(:district)
    json = district.to_json
    assert_no_match /district/, json
    assert_match /id/, json
    assert_match /name/, json    
  end
end
