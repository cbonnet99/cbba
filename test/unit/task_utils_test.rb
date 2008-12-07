require File.dirname(__FILE__) + '/../test_helper'

class TaskUtilsTest < ActiveSupport::TestCase
	fixtures :all

	def test_count_users
		practitioners = categories(:practitioners)
		hypnotherapy = subcategories(:hypnotherapy)
		TaskUtils.count_users
		practitioners.reload
		assert_equal 6, practitioners.users_counter
		hypnotherapy.reload
		assert_equal 4, hypnotherapy.users_counter
	end

  def test_create_default_admins
    old_size = User.all.size
    TaskUtils.create_default_admins
    # #user cbonnet99@gmail.com already exists in the test data (and so won't be
    # created) hence the -1
    assert_equal old_size+$admins.size-1, User.all.size
  end

  def test_rotate_user_positions_in_subcategories
    canterbury = regions(:canterbury)
    canterbury_christchurch_city = districts(:canterbury_christchurch_city)
    hypnotherapy = subcategories(:hypnotherapy)
    results = User.search_results(nil, hypnotherapy.id, canterbury.id, nil, 1)
    TaskUtils.rotate_user_positions_in_subcategories
    new_results = User.search_results(nil, hypnotherapy.id, canterbury.id, nil, 1)
    # #first full membe should have changed
    assert new_results.first != results.first

    old_user_size = User.all.size
    # #another hypnoptherapist in Chrischurch!
    user = User.new(:first_name => "Joe", :last_name => "Test", :district_id => canterbury_christchurch_city.id,
      :region_id => canterbury.id, :email => "joe@test.com",
      :membership_type => "full_member", :professional => true, :subcategory1_id => hypnotherapy.id,
      :password => "blablabla", :password_confirmation => "blablabla" )
    user.register!
    user.activate!
    user.roles << Role.find_by_name("full_member")
    assert_equal old_user_size+1, User.all.size
    after_insert_results = User.search_results(nil, hypnotherapy.id, canterbury.id, nil, 1)
    #the new user should be in last place
#    puts "============= after_insert_results:"
#    after_insert_results.each do |r|
#      puts r.name, r.free_listing
#    end
    assert after_insert_results.first == new_results.first
    assert after_insert_results.last != new_results.last
  end
end
