require File.dirname(__FILE__) + '/../test_helper'

class UserProfileTest < ActiveSupport::TestCase
  def test_reviewable
    assert_equal 3, UserProfile.count_reviewable
    assert_equal 3, UserProfile.reviewable.size
  end
end
