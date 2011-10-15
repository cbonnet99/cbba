require File.dirname(__FILE__) + '/../test_helper'

class CountryTest < ActiveSupport::TestCase

  def test_extract_country_code_from_host
    assert_equal countries(:nz), Country.extract_country_code_from_host("nz.zingabeam.com")
    assert_equal countries(:au), Country.extract_country_code_from_host("au.zingabeam.com")
  end

  def test_extract_country_code_from_host_default
    assert_equal countries(:au), Country.extract_country_code_from_host("www.zingabeam.com")
  end

  def test_featured_full_members
    cyrille = users(:cyrille)
    TaskUtils.rotate_users
    cyrille.reload
    assert_equal [cyrille], countries(:nz).featured_full_members
  end

end
