require File.dirname(__FILE__) + '/../test_helper'

class CountryTest < ActiveSupport::TestCase

  def test_featured_full_members
    cyrille = users(:cyrille)
    TaskUtils.rotate_feature_ranks
    cyrille.reload
    assert_equal [cyrille], countries(:nz).featured_full_members
  end

end
