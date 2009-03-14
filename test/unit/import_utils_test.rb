require File.dirname(__FILE__) + '/../test_helper'

class ImportUtilsTest < ActiveSupport::TestCase


  def test_import_categories
    ImportUtils.import_categories
  end

  def test_import_subcategories
    ImportUtils.import_subcategories
  end

  def test_decompose_phone_number
    assert_equal ['09', '1234567'], ImportUtils.decompose_phone_number(" 09-123 45-67")
  end

  def test_decompose_mobile_number
    assert_equal ['021', '1234567'], ImportUtils.decompose_mobile_number(" 021-123 45-67")
  end

	def test_import_districts
		old_count = District.count
		ImportUtils.import_districts
		assert District.count > old_count
	end
	def test_import_users
		old_count = District.count
		ImportUtils.import_districts
		assert District.count > old_count
		old_count_users = User.count
		ImportUtils.import_users("small_users.csv")
		assert User.count > old_count_users
		yoga_daily = User.find_by_email("info@yogaindailylife.org.nz")
		assert !yoga_daily.receive_newsletter?
		assert yoga_daily.free_listing?
    assert_equal 1, yoga_daily.roles.find_all_by_name("free_listing").size
		assert yoga_daily.free_listing?
		assert !yoga_daily.subcategories.empty?
		assert !yoga_daily.categories.empty?
		assert_not_nil yoga_daily.subcategories.first.category
		annette = User.find_by_email("annette@bodysystems.co.nz")
		assert annette.receive_newsletter?
		assert annette.full_member?
		assert !annette.phone.blank?
    assert_equal 1, annette.roles.find_all_by_name("full_member").size
    assert_not_nil annette.user_profile
    assert_equal "1 October 2007", annette.member_since.to_date.to_s.strip
    assert_equal "1 May 2009", annette.member_until.to_date.to_s.strip
		angela = User.find_by_email("angela.baines@paradise.net")
    assert_equal "04-9051451", angela.phone
    assert_equal "021-1103239", angela.mobile


    assert_equal 4, annette.tabs.size
    assert !annette.tabs.first.title.starts_with?("About")
    assert annette.tabs.last.title.starts_with?("About")
		assert_not_equal "-", annette.phone
		assert_equal 'active', annette.state

    #first name (and other fields) should be stripped of empty spaces ("Anne", not "Anne ")
    assert_not_nil User.find_by_first_name("Anne")
	end
end