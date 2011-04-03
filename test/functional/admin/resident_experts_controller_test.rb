require File.dirname(__FILE__) + '/../../test_helper'

class Admin::ResidentExpertsControllerTest < ActionController::TestCase
  def test_index
    #fixtures: create a user with points
    subcat = Factory(:subcategory)
    user = Factory(:user, :subcategory1_id => subcat.id)
    article = Factory(:article, :author => user, :subcategory1_id => subcat.id, :state => "draft")
    article.publish!    
    
    get :index, {}, {:user_id => users(:cyrille).id }
    assert_response :success
    assert !assigns(:subcategories).blank?
  end
  def test_index_for_subcategory
    get :index_for_subcategory, {:id => subcategories(:yoga).id }, {:user_id => users(:cyrille).id }
    assert_response :success
  end
end
