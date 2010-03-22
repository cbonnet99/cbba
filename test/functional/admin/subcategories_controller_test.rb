require File.dirname(__FILE__) + '/../../test_helper'

class Admin::SubcategoriesControllerTest < ActionController::TestCase
  fixtures :all
  
  def test_create
    old_size = Subcategory.all.size
    post :create, {:subcategory => {:name => "Test", :category_id => categories(:coaches).id, :description => "Bla"}}, {:user_id => users(:cyrille).id }
    assert_redirected_to new_admin_subcategory_url
    assert_not_nil flash[:notice]
    assert_equal old_size+1, Subcategory.all.size
  end
  
  def test_index
    get :index, {}, {:user_id => users(:cyrille).id }
    assert_response :success
    assert !assigns(:subcategories).blank?
  end
  
  def test_destroy
    s = subcategories(:yoga)
    old_size = Subcategory.all.size
    post :destroy, {:id => s.slug}, {:user_id => users(:cyrille).id }
    assert_not_nil flash[:error], "Flash: #{flash.inspect}"
    assert_equal old_size, Subcategory.all.size
  end
  
  def test_destroy_and_transfer_with_resident_expert
    delete = subcategories(:hypnotherapy)
    transfer_to = subcategories(:life_coaching)
    users = delete.users
    old_size = Subcategory.all.size
    post :destroy, {:id => delete.slug, :new_subcategory_id => transfer_to.id}, {:user_id => users(:cyrille).id }
    assert_not_nil flash[:error], "Flash: #{flash.inspect}"
    assert_equal old_size, Subcategory.all.size
  end
  
  def test_destroy_and_transfer
    delete = subcategories(:business_coaching)
    transfer_to = subcategories(:life_coaching)
    users = delete.users
    transferred_users_size = users.size
    old_users_size = transfer_to.users.size
    old_size = Subcategory.all.size
    post :destroy, {:id => delete.slug, :new_subcategory_id => transfer_to.id}, {:user_id => users(:cyrille).id }
    assert_not_nil flash[:notice], "Flash: #{flash.inspect}"
    assert_equal old_size-1, Subcategory.all.size
    users.each do |u|
      u.reload
      assert u.subcategories.include?(transfer_to), "#{u.name} should have #{transfer_to.name}, but subcats are: #{u.subcategories.map(&:name).to_sentence}"
      assert !u.subcategories.include?(delete), "#{u.name} should NOT have #{delete.name}, but subcats are: #{u.subcategories.map(&:name).to_sentence}"
    end
    transfer_to.reload
    users.each do |u|
      assert transfer_to.users.include?(u)
    end
    
    assert_equal old_users_size+transferred_users_size, transfer_to.users.size
  end
  
end