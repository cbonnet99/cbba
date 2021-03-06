require File.dirname(__FILE__) + '/../test_helper'

class SpecialOfferTest < ActiveSupport::TestCase
  fixtures :all
  
  def test_count_after_publish
    cyrille = users(:cyrille)
    nz = cyrille.country
    yoga = subcategories(:yoga)
    assert cyrille.special_offers.published.size < cyrille.paid_special_offers
    old_size = yoga.published_special_offers_count(nz)
    so = Factory(:special_offer, :subcategory => yoga, :author => cyrille)
    yoga.reload
    assert_equal old_size, yoga.published_special_offers_count(nz)
    assert so.paid_items_left?
    res = so.publish!
    assert res
    assert so.published?
    yoga.reload
    assert_equal old_size+1, yoga.published_special_offers_count(nz)
  end
  
  def test_count_published
    nz = countries(:nz)
    assert_equal 4, SpecialOffer.count_published(nz)
  end
  
  def test_latest
    assert !SpecialOffer.latest.blank?
  end
  
  def test_last_2_months
    assert_equal 4, SpecialOffer.published_in_last_2_months.size
  end
end
