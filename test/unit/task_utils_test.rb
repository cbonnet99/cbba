require File.dirname(__FILE__) + '/../test_helper'

class TaskUtilsTest < ActiveSupport::TestCase
	fixtures :all

  def test_suspend_full_members_when_membership_expired
    cyrille = users(:cyrille)
    old_size = User.active.size
    TaskUtils.suspend_full_members_when_membership_expired
    #no full member to suspend
    assert_equal old_size, User.active.size
    cyrille.member_until = 1.day.ago
    cyrille.save!
    cyrille.reload
    TaskUtils.suspend_full_members_when_membership_expired

    cyrille.reload
    #cyrille should have been suspended
    assert_equal old_size-1, User.active.size
  end

  def test_mark_down_old_full_members
    norma = users(:norma)
    rmoore = users(:rmoore)
    assert norma.new_user?
    assert rmoore.new_user?
    TaskUtils.mark_down_old_full_members
    norma.reload
    assert !norma.new_user?
    assert rmoore.new_user?

  end

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
    sav = User.find_by_email("sav@elevatecoaching.co.nz")
    assert_not_nil sav
    assert sav.admin?
    assert !sav.free_listing?
  end

  def test_create_default_admins_after_import_users
    ImportUtils.import_districts
    ImportUtils.import_users("small_users.csv")
    TaskUtils.create_default_admins
    #Norma exists in users
    norma = User.find_by_email("norma@eurekacoaching.co.nz")
    assert_not_nil norma
    assert norma.admin?
    assert !norma.free_listing?
  end

  def test_rotate_user_positions_in_subcategories
    canterbury = regions(:canterbury)
    canterbury_christchurch_city = districts(:canterbury_christchurch_city)
    hypnotherapy = subcategories(:hypnotherapy)
    results = User.search_results(nil, hypnotherapy.id, canterbury.id, nil, 1)
#     puts "============= results:"
#     results.each do |r|
#       puts "#{r.name}  - #{r.free_listing}- #{r.id}"
#       r.subcategories_users.each do |su|
#         puts "+++++++++ #{su.subcategory_id} - #{su.position}"
#       end
#     end

    TaskUtils.rotate_user_positions_in_subcategories
    new_results = User.search_results(nil, hypnotherapy.id, canterbury.id, nil, 1)
    new_results_size = new_results.size
    # #first full member should have changed
    assert new_results.first != results.first

#     puts "============= new_results:"
#     new_results.each do |r|
#       puts "#{r.name}  - #{r.free_listing}- #{r.id}"
#       r.subcategories_users.each do |su|
#         puts "+++++++++ #{su.subcategory_id} - #{su.position}"
#       end
#     end
    old_user_size = User.all.size
    # #another hypnoptherapist in Chrischurch!
    user = User.new(:first_name => "Joe", :last_name => "Test", :district_id => canterbury_christchurch_city.id,
      :region_id => canterbury.id, :email => "joe@test.com",
      :membership_type => "full_member", :professional => true, :subcategory1_id => hypnotherapy.id,
      :password => "blablabla", :password_confirmation => "blablabla" )
    user.register!

    user.activate!
    user.subcategories_users.reload
    assert_equal 1, user.subcategories_users.size
    assert_equal old_user_size+1, User.all.size
    after_insert_results = User.search_results(nil, hypnotherapy.id, canterbury.id, nil, 1)
    #the new user should be the last of the full members
#    puts "============= after_insert_results:"
#    after_insert_results.each do |r|
#      puts "#{r.name}  - #{r.free_listing}"
#       r.subcategories_users.each do |su|
#         puts "+++++++++ #{su.subcategory_id} - #{su.position}"
#       end
#    end
   
    #only one result should have been added
    assert_equal new_results_size+1, after_insert_results.size
    assert after_insert_results.first == new_results.first
    
    last_full_member_new = new_results.select{|m| !m.free_listing?}.last
    last_full_member_after_insert = after_insert_results.select{|m| !m.free_listing?}.last
    assert last_full_member_new != last_full_member_after_insert
  end
end
