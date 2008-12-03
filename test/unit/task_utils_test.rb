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

  def test_create_default_admins
    old_size = User.all.size
    TaskUtils.create_default_admins
    #user cbonnet99@gmail.com already exists in the test data (and so won't be created) hence the -1
    assert_equal old_size+$admins.size-1, User.all.size
  end

  def test_rotate_user_positions_in_subcategories
    canterbury = regions(:canterbury)
    hypnotherapy = subcategories(:hypnotherapy)
    results = User.search_results(nil, hypnotherapy.id, canterbury.id, nil, 1)
    TaskUtils.rotate_user_positions_in_subcategories
    new_results = User.search_results(nil, hypnotherapy.id, canterbury.id, nil, 1)
    assert new_results.first != results.first
  end
end
