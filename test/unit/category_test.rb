require File.dirname(__FILE__) + '/../test_helper'

class CategoryTest < ActiveSupport::TestCase

	fixtures :all

  def test_from_param
    practitioners = categories(:practitioners)
    assert_equal practitioners, Category.from_param(practitioners.name)
    assert_nil Category.from_param('')
  end

  def test_list_categories
    practitioners = categories(:practitioners)
		coaching = categories(:coaching)
		assert_equal practitioners, Category.list_categories.first
		assert_equal coaching, Category.list_categories.last
  end
end
