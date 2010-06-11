require File.dirname(__FILE__) + '/../test_helper'

class SpecialOfferTest < ActiveSupport::TestCase
  fixtures :all
  
  def test_count_after_publish
    cyrille = users(:cyrille)
    yoga = subcategories(:yoga)
    assert cyrille.special_offers.published.size < cyrille.paid_special_offers
    old_size = yoga.published_special_offers_count
    so = Factory(:special_offer, :subcategory => yoga, :author => cyrille)
    yoga.reload
    assert_equal old_size, yoga.published_special_offers_count
    assert so.paid_items_left?
    res = so.publish!
    assert res
    assert so.published?
    yoga.reload
    assert_equal old_size+1, yoga.published_special_offers_count
  end
  
  def test_count_published_special_offers
    assert_equal 4, SpecialOffer.count_published_special_offers
  end
  
  def test_latest
    assert !SpecialOffer.latest.blank?
  end
  
  def test_last_2_months
    assert_equal 4, SpecialOffer.published_in_last_2_months.size
  end
end
