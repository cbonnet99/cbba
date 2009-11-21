require File.dirname(__FILE__) + '/../test_helper'

class TabsControllerTest < ActionController::TestCase
  include ApplicationHelper
  fixtures :all
  
  def test_create_too_many
    rmoore = users(:rmoore)
    rmoore.tabs.create(:title => "Test3", :content => "My content" )
    rmoore.reload
    rmoore.tabs.reload
    post :create, { }, {:user_id => rmoore.id }
    assert_nil assigns(:tab)
    assert "Sorry, you can only have 3 tabs", flash[:error]
  end

  def test_move
    sgardiner = users(:sgardiner)
    sgardiner_hypnotherapy = tabs(:sgardiner_hypnotherapy)
    post :move_right, {:id => sgardiner_hypnotherapy.slug }, {:user_id => sgardiner.id }
    sgardiner_hypnotherapy.reload
    assert_equal 2, sgardiner_hypnotherapy.position
    post :move_left, {:id => sgardiner_hypnotherapy.slug }, {:user_id => sgardiner.id }
    sgardiner_hypnotherapy.reload
    assert_equal 1, sgardiner_hypnotherapy.position
  end

  def test_tabs
    cyrille = users(:cyrille)
    old_size = Tab.all.size
    post :create, {:tab => {:title => "bla", :content => "this is a new tab"} }, {:user_id => cyrille.id }
    assert_not_nil assigns(:tab)
    assert_equal 0, assigns(:tab).errors.size
    assert_equal old_size+1, Tab.all.size
    post :destroy, {:id => assigns(:tab).slug }, {:user_id => cyrille.id }
    assert_equal old_size, Tab.all.size
  end

  def test_update
    norma = users(:norma)
    norma_hypnotherapy = tabs(:norma_hypnotherapy)
    yoga = subcategories(:yoga)
    assert !norma.subcategories.include?(yoga)
    old_title = norma_hypnotherapy.title
    post :update, {:id => norma_hypnotherapy.slug, :tab => {:old_title => old_title, :title => yoga.name, :content => "this is a new tab"} }, {:user_id => norma.id }
    norma.reload
    norma.tabs.reload
    norma_hypnotherapy.reload
    assert_equal yoga.name, norma_hypnotherapy.title
    assert !norma.tabs.map(&:title).include?(old_title), "Tabs should not contain #{old_title} anymore. Tabs are: #{norma.tabs.inspect}"
    assert norma.tabs.map(&:title).include?(yoga.name)
    norma.subcategories.reload
    assert norma.subcategories.include?(yoga), "Yoga should have been added to Norma's profile, as it was selected for a tab, subcategories were: #{norma.subcategories.map(&:name).to_sentence}"
  end

  def test_destroy
    cyrille = users(:cyrille)
    cyrille_hypnotherapy = tabs(:cyrille_hypnotherapy)
    old_size = Tab.all.size
    post :destroy, {:id => cyrille_hypnotherapy.slug}, {:user_id => cyrille.id }
    assert_equal old_size-1, Tab.all.size
    assert_redirected_to expanded_user_url(cyrille)
  end

end
