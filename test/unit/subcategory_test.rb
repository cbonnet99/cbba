require File.dirname(__FILE__) + '/../test_helper'

class SubcategoryTest < ActiveSupport::TestCase
	fixtures :all

  def test_last_subcat_or_member_created_at
    old_last = Subcategory.last_subcat_or_member_created_at
    new_subcat = Factory(:subcategory)
    assert Subcategory.last_subcat_or_member_created_at > old_last
    assert_equal Subcategory.last_subcat_or_member_created_at, new_subcat.created_at
  end

  def test_last_subcat_or_member_created_at2
    subcat = Factory(:subcategory)
    old_last = Subcategory.last_subcat_or_member_created_at
    new_user = Factory(:user, :subcategory1_id => subcat.id )
    assert_equal old_last, Subcategory.last_subcat_or_member_created_at
    new_user.user_profile.publish!
    assert Subcategory.last_subcat_or_member_created_at > old_last
    assert_equal Subcategory.last_subcat_or_member_created_at, new_user.user_profile.published_at
  end

  def test_last_articles
    subcat = Factory(:subcategory)
    cat = subcat.category
    8.times do
     Factory(:article, :subcategories => [subcat], :categories => [cat], :subcategory1_id => subcat.id, :state => "published")
   end
   assert_equal 6, subcat.last_articles(6).size
  end

  def test_users_hash_by_region
    hash = subcategories(:hypnotherapy).users_hash_by_region
    assert !hash.blank?
    assert hash.keys.include?(regions(:wellington).name)
    assert hash[regions(:wellington).name].is_a?(Array)
    assert hash[regions(:wellington).name].size > 1
  end

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
		assert_equal "must be unique", new_subcat.errors.on(:name)
  end
end
