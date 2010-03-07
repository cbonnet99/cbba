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
    s = Subcategory.first
    old_size = Subcategory.all.size
    post :destroy, {:id => s.slug}, {:user_id => users(:cyrille).id }
    assert_equal old_size-1, Subcategory.all.size
  end
end