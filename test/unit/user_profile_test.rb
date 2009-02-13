require File.dirname(__FILE__) + '/../test_helper'

class UserProfileTest < ActiveSupport::TestCase
  def test_reviewable
    assert_equal 2, UserProfile.count_reviewable
    assert_equal 2, UserProfile.reviewable.size
  end
end
