require File.dirname(__FILE__) + '/../test_helper'

class CategoryTest < ActiveSupport::TestCase

	fixtures :all

  def test_list_categories
    practitioners = categories(:practitioners)
		courses = categories(:courses)
		assert_equal practitioners, Category.list_categories.first
		assert_equal courses, Category.list_categories.last
  end
end
