require File.dirname(__FILE__) + '/../test_helper'

class SpecialOfferTest < ActiveSupport::TestCase
  fixtures :all
  
  def test_count_published_special_offers
    assert_equal 2, SpecialOffer.count_published_special_offers
  end
  
  def test_latest
    assert !SpecialOffer.latest.blank?
  end
  
  def test_last_2_months
    assert_equal 2, SpecialOffer.published.last_2_months.size
  end
end
