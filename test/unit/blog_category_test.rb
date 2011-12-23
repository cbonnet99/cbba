require File.dirname(__FILE__) + '/../test_helper'

class BlogCategoryTest < ActiveSupport::TestCase
  def test_random
    assert BlogCategory.random.is_a?(BlogCategory)
  end
end
