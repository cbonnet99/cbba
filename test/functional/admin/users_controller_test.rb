require File.dirname(__FILE__) + '/../../test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
  fixtures :all
  
  def test_login
    cyrille = users(:cyrille)
    rmoore = users(:rmoore)
    post :login, {:id => rmoore.id }, {:user_id => cyrille.id}
    assert_redirected_to :controller => "/users", :action => "edit"  
  end
  
  def test_search
    cyrille = users(:cyrille)
    post :search, {:search_term => "cy"}, {:user_id => cyrille.id }
    assert_response :success
    assert !assigns(:users).blank?
    assert assigns(:users).include?(cyrille)
  end
end
