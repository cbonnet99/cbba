require File.dirname(__FILE__) + '/../test_helper'

class TaskUtilsTest < ActiveSupport::TestCase
	fixtures :all

	def test_count_users
		practitioners = categories(:practitioners)
		hypnotherapy = subcategories(:hypnotherapy)
		TaskUtils.count_users
		practitioners.reload
		assert_equal 3, practitioners.users_counter
		hypnotherapy.reload
		assert_equal 3, hypnotherapy.users_counter
	end
end
