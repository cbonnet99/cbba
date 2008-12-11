require File.dirname(__FILE__) + '/../test_helper'

class TaskUtilsTest < ActiveSupport::TestCase
	fixtures :all

	def test_count_users
		practitioners = categories(:practitioners)
		hypnotherapy = subcategories(:hypnotherapy)
		TaskUtils.count_users
		practitioners.reload
		assert_equal 7, practitioners.users_counter
		hypnotherapy.reload
		assert_equal 5, hypnotherapy.users_counter
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
    # puts "============= results:"
    # results.each do |r|
    #   puts "#{r.name}  - #{r.free_listing}"
    # end
    TaskUtils.rotate_user_positions_in_subcategories
    new_results = User.search_results(nil, hypnotherapy.id, canterbury.id, nil, 1)
    new_results_size = new_results.size
    # #first full member should have changed
    assert new_results.first != results.first

    # puts "============= new_results:"
    # new_results.each do |r|
    #   puts "#{r.name}  - #{r.free_listing}"
    # end
    old_user_size = User.all.size
    # #another hypnoptherapist in Chrischurch!
    user = User.new(:first_name => "Joe", :last_name => "Test", :district_id => canterbury_christchurch_city.id,
      :region_id => canterbury.id, :email => "joe@test.com",
      :membership_type => "full_member", :professional => true, :subcategory1_id => hypnotherapy.id,
      :password => "blablabla", :password_confirmation => "blablabla" )
    user.register!
    user.activate!
    assert_equal old_user_size+1, User.all.size
    after_insert_results = User.search_results(nil, hypnotherapy.id, canterbury.id, nil, 1)
    #the new user should be the last of the full members
   # puts "============= after_insert_results:"
   # after_insert_results.each do |r|
   #   puts "#{r.name}  - #{r.free_listing}"
   # end
   
    #only one result should have been added
    assert_equal new_results_size+1, after_insert_results.size
    assert after_insert_results.first == new_results.first
    
    last_full_member_new = new_results.select{|m| !m.free_listing?}.last
    last_full_member_after_insert = after_insert_results.select{|m| !m.free_listing?}.last
    assert last_full_member_new != last_full_member_after_insert
  end
end
