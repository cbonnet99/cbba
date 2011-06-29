require File.dirname(__FILE__) + '/../test_helper'

class SubcategoryTest < ActiveSupport::TestCase
	fixtures :all

  def test_with_articles
    au = countries(:au)
    nz = countries(:nz)
    subcat = Factory(:subcategory)
    user_au = Factory(:user, :country => au)
    article_au = Factory(:article, :subcategory1_id => subcat.id, :state => "draft", :author => user_au)
    article_au.publish!
    
    assert Subcategory.with_articles(au).include?(subcat)
    assert !Subcategory.with_articles(nz).include?(subcat)
  end

  def test_with_special_offers
    au = countries(:au)
    nz = countries(:nz)
    subcat = Factory(:subcategory)
    user_au = Factory(:user, :country => au, :paid_special_offers => 2)
    so_au = Factory(:special_offer, :subcategory_id => subcat.id, :state => "draft", :author => user_au)
    so_au.publish!
    
    assert Subcategory.with_special_offers(au).include?(subcat)
    assert !Subcategory.with_special_offers(nz).include?(subcat)
  end

  def test_with_gift_vouchers
    au = countries(:au)
    nz = countries(:nz)
    subcat = Factory(:subcategory)
    user_au = Factory(:user, :country => au, :paid_gift_vouchers => 2)
    gv_au = Factory(:gift_voucher, :subcategory_id => subcat.id, :state => "draft", :author => user_au)
    published = gv_au.publish!
    
    assert published, "Gift voucher was not published successfully"
    assert Subcategory.with_gift_vouchers(au).include?(subcat)
    assert !Subcategory.with_gift_vouchers(nz).include?(subcat)
  end


  def test_published_articles_count
    au = countries(:au)
    nz = countries(:nz)
    subcat = Factory(:subcategory)
    user_au = Factory(:user, :country => au)
    user_nz = Factory(:user, :country => nz)
    so_au = Factory(:article, :subcategory1_id => subcat, :state => "draft", :author => user_au, :country => au)
    so_nz = Factory(:article, :subcategory1_id => subcat, :state => "draft", :author => user_nz, :country => nz)
    au_published = so_au.publish!
    nz_published = so_nz.publish!
    
    assert au_published
    assert nz_published    
    assert_equal 1, subcat.published_articles_count(au)
    assert_equal 1, subcat.published_articles_count(nz)
  end

  def test_published_special_offers_count
    au = countries(:au)
    nz = countries(:nz)
    subcat = Factory(:subcategory)
    user_au = Factory(:user, :country => au, :paid_special_offers => 2)
    user_nz = Factory(:user, :country => nz, :paid_special_offers => 2)
    so_au = Factory(:special_offer, :subcategory => subcat, :state => "draft", :author => user_au)
    so_nz = Factory(:special_offer, :subcategory => subcat, :state => "draft", :author => user_nz)
    au_published = so_au.publish!
    nz_published = so_nz.publish!
    
    assert au_published
    assert nz_published
    assert_equal 1, subcat.published_special_offers_count(au)
    assert_equal 1, subcat.published_special_offers_count(nz)
  end

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
