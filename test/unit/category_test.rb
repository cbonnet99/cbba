require File.dirname(__FILE__) + '/../test_helper'

class CategoryTest < ActiveSupport::TestCase

	fixtures :all

  def test_list_categories
    practicioners = categories(:practicioners)
		courses = categories(:courses)
		assert_equal practicioners, Category.list_categories.first
		assert_equal courses, Category.list_categories.last
  end
end
