require File.dirname(__FILE__) + '/../test_helper'

class TabsControllerTest < ActionController::TestCase
  include ApplicationHelper
  fixtures :all

  def test_create
    cyrille = users(:cyrille)
    old_size = cyrille.tabs.size
    post :create, { }, {:user_id => cyrille.id }
    assert_not_nil assigns(:tab)
    assert_redirected_to action_tab_with_id_url(assigns(:tab).slug, :action => "edit" )
    cyrille.reload
    assert_equal old_size+1, cyrille.tabs.size
  end
  
  def test_create_too_many
    cyrille = users(:cyrille)
    cyrille.tabs.create(:title => "Test3", :content => "My content" )
    cyrille.reload
    cyrille.tabs.reload
    post :create, { }, {:user_id => cyrille.id }
    assert_nil assigns(:tab)
    assert "Sorry, you can only have 3 tabs", flash[:error]
  end

  def test_move
    cyrille = users(:cyrille)
    cyrille_test = tabs(:cyrille_test)
    post :move_right, {:id => cyrille_test.slug }, {:user_id => cyrille.id }
    cyrille_test.reload
    assert_equal 2, cyrille_test.position
    post :move_left, {:id => cyrille_test.slug }, {:user_id => cyrille.id }
    cyrille_test.reload
    assert_equal 1, cyrille_test.position
  end

  def test_tabs
    cyrille = users(:cyrille)
    old_size = Tab.all.size
    post :create, {:title => "bla", :content => "this is a new tab" }, {:user_id => cyrille.id }
    assert_not_nil assigns(:tab)
    assert_equal 0, assigns(:tab).errors.size
    assert_equal old_size+1, Tab.all.size
    post :destroy, {:id => assigns(:tab).slug }, {:user_id => cyrille.id }
    assert_equal old_size, Tab.all.size
  end

  def test_update
    cyrille = users(:cyrille)
    cyrille_test = tabs(:cyrille_test)
    post :update, {:id => cyrille_test.slug, :tab => {:title => "bla", :content => "this is a new tab"} }, {:user_id => cyrille.id }
    cyrille_test.reload
    assert_equal "bla", cyrille_test.title
    assert_equal "bla", cyrille_test.slug
  end

  def test_destroy
    cyrille = users(:cyrille)
    cyrille_test = tabs(:cyrille_test)
    old_size = Tab.all.size
    post :destroy, {:id => cyrille_test.slug}, {:user_id => cyrille.id }
    assert_equal old_size-1, Tab.all.size
    assert_redirected_to expanded_user_url(cyrille)
  end

end
