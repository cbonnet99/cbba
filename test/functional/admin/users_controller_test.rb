require File.dirname(__FILE__) + '/../../test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
  fixtures :all
  
  def test_login
    cyrille = users(:cyrille)
    rmoore = users(:rmoore)
    post :login, {:id => rmoore.slug }, {:user_id => cyrille.id}
    assert_redirected_to :controller => "/users", :action => "edit"  
  end
  
  def test_deactivate
    cyrille = users(:cyrille)
    user = Factory(:user)
    user.user_profile.publish!
    old_size = User.all.size
    post :deactivate, {:id => user.slug }, {:user_id => cyrille.id}
    assert_redirected_to search_admin_users_url
    
    user.reload
    assert_not_nil user
    assert !user.active?
    assert !user.published?
    
    post :reactivate, {:id => user.slug }, {:user_id => cyrille.id }
    assert_redirected_to search_admin_users_url
    user.reload
    assert_not_nil user
    assert user.active?
    assert user.published?
    
  end
  
  def test_deactivate_unpublished_profile
    cyrille = users(:cyrille)
    user = Factory(:user)
    old_size = User.all.size
    post :deactivate, {:id => user.slug }, {:user_id => cyrille.id}
    assert_redirected_to search_admin_users_url
    
    user.reload
    assert_not_nil user
    assert !user.active?
    assert !user.published?
  end
  
  def test_warning_deactivate
    cyrille = users(:cyrille)
    user = Factory(:user, :paid_special_offers => 1, :paid_gift_vouchers => 1)
    user.user_profile.publish!
    so = Factory(:special_offer, :author => user )
    so.publish!
    assert so.published?
    gv = Factory(:gift_voucher, :author => user )
    gv.publish!
    assert gv.published?
    
    post :deactivate, {:id => user.slug }, {:user_id => cyrille.id}
    
    assert_redirected_to warning_deactivate_admin_user_url
    user.reload
    assert_not_nil user
    assert user.active?
    assert user.published?
    
    so.reload
    assert so.published?
    gv.reload
    assert gv.published?
  end

  def test_deactivate_confirm
    cyrille = users(:cyrille)
    user = Factory(:user, :paid_special_offers => 1, :paid_gift_vouchers => 1)
    user.user_profile.publish!
    so = Factory(:special_offer, :author => user )
    so.publish!
    assert so.published?
    gv = Factory(:gift_voucher, :author => user )
    gv.publish!
    assert gv.published?
    
    post :deactivate, {:confirm => "true", :id => user.slug}, {:user_id => cyrille.id}
    
    assert_redirected_to search_admin_users_url
    user.reload
    assert_not_nil user
    assert !user.active?
    assert !user.published?
    
    so.reload
    assert !so.published?
    gv.reload
    assert !gv.published?
    
    user.subcategories_users.reload
    assert user.subcategories_users.reject{|su| su.points==0}.blank?, "user.subcategories_users: #{user.subcategories_users.inspect}"
  end
  
  
  def test_search
    cyrille = users(:cyrille)
    post :search, {:search_term => "cy"}, {:user_id => cyrille.id }
    assert_response :success
    assert assigns(:users).blank?
    assert !assigns(:users).include?(cyrille)
  end

  def test_search_with_status_active
    cyrille = users(:cyrille)
    inactive_user = Factory(:user, :state => "inactive")
    post :search, {:search_term => "cy", :user_status_active => "active" }, {:user_id => cyrille.id }
    assert_response :success
    assert !assigns(:users).blank?
    assert assigns(:users).include?(cyrille)
  end
  

  def test_search_with_status_inactive
    cyrille = users(:cyrille)
    inactive_user = Factory(:user, :state => "inactive")
    post :search, {:search_term => "", :user_status_inactive => "inactive" }, {:user_id => cyrille.id }
    assert_response :success
    assert !assigns(:users).blank?
    assert !assigns(:users).include?(cyrille)
    assert assigns(:users).include?(inactive_user)
  end

  def test_search_with_multiple_status
    cyrille = users(:cyrille)
    inactive_user = Factory(:user, :first_name => "Cylene", :state => "inactive")
    post :search, {:search_term => "cy", :user_status_inactive => "inactive", :user_status_active => "active" }, {:user_id => cyrille.id }
    assert_response :success
    assert !assigns(:users).blank?
    assert assigns(:users).include?(cyrille)
    assert assigns(:users).include?(inactive_user)
  end
  
  def test_update
    norma = users(:norma)
    old_member_since = norma.member_since
    old_member_until = norma.member_until
    cyrille = users(:cyrille)
    post :update, {:id => norma.slug, :user => {:admin => "0", :main_role => "Free listing", "member_since(1i)" => "2008",
       "member_since(2i)" => "10", "member_since(3i)" => "30", "member_until(1i)" => "2009",
          "member_until(2i)" => "11", "member_until(3i)" => "1" }  }, {:user_id => cyrille.id}
    assert_not_nil assigns(:selected_user)
    assert assigns(:selected_user).errors.blank?, "Errors: #{assigns(:selected_user).errors.full_messages.to_sentence}"
    assert_redirected_to search_admin_users_url
    norma.reload
    assert norma.free_listing?
    assert !norma.admin?, "Norma should not be admin"
    assert !norma.full_member?
    assert_equal old_member_since, norma.member_since
    assert_equal old_member_until, norma.member_until
  end
  
  def test_update_free_to_full_member
    rmoore = users(:rmoore)
    old_member_since = rmoore.member_since
    old_member_until = rmoore.member_until
    old_resident_since = rmoore.resident_since
    old_resident_until = rmoore.resident_until
    cyrille = users(:cyrille)
    post :update, {:id => rmoore.slug, :user => {:admin => 0, :main_role => "Full member", "member_since(1i)" => "2008",
       "member_since(2i)" => "10", "member_since(3i)" => "30", "member_until(1i)" => "2009",
          "member_until(2i)" => "11", "member_until(3i)" => "1" }  }, {:user_id => cyrille.id}
    assert_redirected_to search_admin_users_url
    rmoore.reload
    assert !rmoore.free_listing?
    assert !rmoore.admin?
    assert rmoore.full_member?
    assert !rmoore.resident_expert?
    assert_equal Time.zone.parse('2008-10-30'), rmoore.member_since
    assert_equal Time.zone.parse('2009-11-1'), rmoore.member_until
    assert_equal old_resident_since, rmoore.resident_since
    assert_equal old_resident_until, rmoore.resident_until
    assert_equal rmoore.subcategories.size, rmoore.tabs.size, "User has #{rmoore.subcategories.size} modalities, so it should have that many tabs"
  end
  
  def test_update_free_to_admin
    rmoore = users(:rmoore)
    cyrille = users(:cyrille)
    post :update, {:id => rmoore.slug, :user => {:admin => "1", :expertise_subcategory_id => subcategories(:addiction_recovery).id, :main_role => "Full member", "member_since(1i)" => "2008",
       "member_since(2i)" => "10", "member_since(3i)" => "30", "member_until(1i)" => "2009",
          "member_until(2i)" => "11", "member_until(3i)" => "1", "resident_since(1i)" => "2008",
             "resident_since(2i)" => "10", "resident_since(3i)" => "30", "resident_until(1i)" => "2009",
                "resident_until(2i)" => "11", "resident_until(3i)" => "1" }  }, {:user_id => cyrille.id}
    assert_redirected_to search_admin_users_url
    rmoore.reload
    assert !rmoore.free_listing?
    assert rmoore.admin?
    assert rmoore.full_member?
    assert !rmoore.resident_expert?
  end
  
end
