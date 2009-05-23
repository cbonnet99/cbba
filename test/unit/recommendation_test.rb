require File.dirname(__FILE__) + '/../test_helper'

class RecommendationTest < ActiveSupport::TestCase
  fixtures :all
  
  def test_recommendations
    cyrille = users(:cyrille)
    assert_equal 2, cyrille.recommendations.size
    assert_equal [cyrille], users(:norma).recommended_by
  end
end
