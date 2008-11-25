require File.dirname(__FILE__) + '/../test_helper'

class SubcategoryTest < ActiveSupport::TestCase
	fixtures :all

  def test_validate
		yoga = subcategories(:yoga)
    new_subcat = Subcategory.create(:category_id => yoga.category_id, :name => yoga.name)
		assert_equal 1, new_subcat.errors.size
		assert_equal "must be unique in this category", new_subcat.errors.on(:name)
  end
end
