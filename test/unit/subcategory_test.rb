require File.dirname(__FILE__) + '/../test_helper'

class SubcategoryTest < ActiveSupport::TestCase
	fixtures :all

  def test_full_name
    assert_equal "Practitioners - Hypnotherapy", subcategories(:hypnotherapy).full_name
  end

  def test_with_resident_expert
    assert_equal 2, Subcategory.with_resident_expert.size
  end

  def test_from_param
    hypnotherapy = subcategories(:hypnotherapy)
    assert_equal hypnotherapy, Subcategory.from_param(hypnotherapy.name)
    assert_nil Subcategory.from_param(nil)
    assert_nil Subcategory.from_param('')
    assert_nil Subcategory.from_param('whatever')
  end

  def test_validate
		yoga = subcategories(:yoga)
    new_subcat = Subcategory.create(:category_id => yoga.category_id, :name => yoga.name)
		assert_equal 1, new_subcat.errors.size
		assert_equal "must be unique in this category", new_subcat.errors.on(:name)
  end
end
