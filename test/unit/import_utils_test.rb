require File.dirname(__FILE__) + '/../test_helper'

class ImporUtilsTest < ActiveSupport::TestCase

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
		ImportUtils.import_users
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


    assert_equal 2, annette.tabs.size
    assert !annette.tabs.first.title.starts_with?("About")
    assert annette.tabs.last.title.starts_with?("About")
		assert_not_equal "-", annette.phone
		assert_equal 'active', annette.state

    #first name (and other fields) should be stripped of empty spaces ("Tracy", not "Tracy ")
    assert_not_nil User.find_by_first_name("Tracy")
	end
end