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
end