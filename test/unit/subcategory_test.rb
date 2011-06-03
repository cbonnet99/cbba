require File.dirname(__FILE__) + '/../test_helper'

class SubcategoryTest < ActiveSupport::TestCase
	fixtures :all

  def test_user_count_for_country
    hypnotherapy = subcategories(:hypnotherapy)
    nz = countries(:nz)
    TaskUtils.count_users
    
    assert hypnotherapy.user_count_for_country(nz) > 0
  end

  def test_last_subcat_or_member_created_at
    nz = countries(:nz)
    old_last = Subcategory.last_subcat_or_member_created_at(nz)
    new_subcat = Factory(:subcategory)
    assert Subcategory.last_subcat_or_member_created_at(nz) > old_last
    assert_equal Subcategory.last_subcat_or_member_created_at(nz), new_subcat.created_at
  end

  def test_last_subcat_or_member_created_at2
    subcat = Factory(:subcategory)
    nz = countries(:nz)
    old_last = Subcategory.last_subcat_or_member_created_at(nz)
    new_user = Factory(:user, :subcategory1_id => subcat.id )
    assert_equal old_last, Subcategory.last_subcat_or_member_created_at(nz)
    new_user.user_profile.publish!
    assert Subcategory.last_subcat_or_member_created_at(nz) > old_last
    assert_equal Subcategory.last_subcat_or_member_created_at(nz).to_date, new_user.user_profile.published_at.to_date
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
    subcat = Factory(:subcategory)
    nz = countries(:nz)
    au = countries(:au)
    new_south_wales_sydney = districts(:new_south_wales_sydney)
    nz_user = Factory(:user, :subcategory1_id => subcat.id, :country => nz)
    au_user = Factory(:user, :subcategory1_id => subcat.id, :country => au, :district => new_south_wales_sydney)
    hash = subcat.users_hash_by_region(nz)
    assert !hash.blank?
    assert hash.keys.include?(nz_user.region.name)
    assert !hash.keys.include?(au_user.region.name)
    assert hash[nz_user.region.name].is_a?(Array)
    assert_equal 1, hash[nz_user.region.name].size
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
