require File.dirname(__FILE__) + '/../test_helper'

class TabsControllerTest < ActionController::TestCase
  include ApplicationHelper
  fixtures :all

  def test_new
    sgardiner = users(:sgardiner)
    get :new, {}, {:user_id => sgardiner.id }
    assert_response :success
  end    
  
  def test_edit
    sgardiner = users(:sgardiner)
    sgardiner_hypnotherapy = tabs(:sgardiner_hypnotherapy)
    get :edit, {:id => sgardiner_hypnotherapy.slug }, {:user_id => sgardiner.id }
    assert_response :success
    assert_select "input[name='tab[old_title]']"
  end
  
  def test_edit_unknown_slug
    sgardiner = users(:sgardiner)
    sgardiner_hypnotherapy = tabs(:sgardiner_hypnotherapy)
    get :edit, {:id => "blabla" }, {:user_id => sgardiner.id }
    assert_response :success
    assert_select "input[name='tab[old_title]']"
  end
  
  def test_create_too_many
    rmoore = users(:rmoore)
    aromatherapy = subcategories(:aromatherapy)
    astrology = subcategories(:astrology)
    old_size = rmoore.subcategories.size
    rmoore.tabs.create(:title => aromatherapy.name, :content => "My content" )
    rmoore.reload
    assert_equal old_size+1, rmoore.subcategories.size
    rmoore.tabs.reload
    post :create, { :title => astrology.name, :content => "My content"}, {:user_id => rmoore.id }
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
    hypnotherapy = subcategories(:hypnotherapy)
    yoga = subcategories(:yoga)
    assert !norma.subcategories.include?(yoga)
    old_title = norma_hypnotherapy.title
    post :update, {:id => norma_hypnotherapy.slug, :tab => {:old_title => old_title, :title => yoga.name, :content1_with => "With me, it's better",
      :content2_benefits => "You'll be relaxed", :content3_training => "MBA with Harvard", :content4_about => "I love kitesurfing"  } }, {:user_id => norma.id }
    norma.reload
    norma.tabs.reload
    norma_hypnotherapy.reload
    assert_equal yoga.name, norma_hypnotherapy.title
    assert_match /MBA with Harvard/, norma_hypnotherapy.content
    assert !norma.tabs.map(&:title).include?(old_title), "Tabs should not contain #{old_title} anymore. Tabs are: #{norma.tabs.inspect}"
    assert norma.tabs.map(&:title).include?(yoga.name)
    norma.subcategories.reload
    assert norma.subcategories.include?(yoga), "Yoga should have been added to Norma's profile, as it was selected for a tab, subcategories were: #{norma.subcategories.map(&:name).to_sentence}"
    assert !norma.subcategories.include?(hypnotherapy), "Hypnotherapy should have been removed from Norma's profile, as it was removed as a tab, subcategories were: #{norma.subcategories.map(&:name).to_sentence}"
  end

  def test_update_legacy
    norma = users(:norma)
    norma_hypnotherapy = tabs(:norma_hypnotherapy)
    hypnotherapy = subcategories(:hypnotherapy)
    yoga = subcategories(:yoga)
    assert !norma.subcategories.include?(yoga)
    old_title = norma_hypnotherapy.title
    post :update, {:id => norma_hypnotherapy.slug, :tab => {:old_title => old_title, :title => yoga.name, :content => "SOMETHING that existed before",  :content1_with => "With me, it's better",
      :content2_benefits => "You'll be relaxed", :content3_training => "MBA with Harvard", :content4_about => "I love kitesurfing"  } }, {:user_id => norma.id }
    norma.reload
    norma.tabs.reload
    norma_hypnotherapy.reload
    assert_equal yoga.name, norma_hypnotherapy.title
    assert_no_match /SOMETHING that existed before/, norma_hypnotherapy.content
    assert_match /MBA with Harvard/, norma_hypnotherapy.content
    assert !norma.tabs.map(&:title).include?(old_title), "Tabs should not contain #{old_title} anymore. Tabs are: #{norma.tabs.inspect}"
    assert norma.tabs.map(&:title).include?(yoga.name)
    norma.subcategories.reload
    assert norma.subcategories.include?(yoga), "Yoga should have been added to Norma's profile, as it was selected for a tab, subcategories were: #{norma.subcategories.map(&:name).to_sentence}"
    assert !norma.subcategories.include?(hypnotherapy), "Hypnotherapy should have been removed from Norma's profile, as it was removed as a tab, subcategories were: #{norma.subcategories.map(&:name).to_sentence}"
  end

  def test_update_strip_invalid_tags
    norma = users(:norma)
    norma_hypnotherapy = tabs(:norma_hypnotherapy)
    hypnotherapy = subcategories(:hypnotherapy)
    yoga = subcategories(:yoga)
    assert !norma.subcategories.include?(yoga)
    old_title = norma_hypnotherapy.title
    post :update, {:id => norma_hypnotherapy.slug, :tab => {:old_title => old_title, :title => yoga.name, :content1_with => "With me, it's better",
      :content2_benefits => "You'll be <h2>relaxed</h2>", :content3_training => "MBA with Harvard", :content4_about => "I love kitesurfing"  } }, {:user_id => norma.id }
    norma.reload
    norma.tabs.reload
    norma_hypnotherapy.reload
    assert_equal yoga.name, norma_hypnotherapy.title
    assert_match %r{You'll be relaxed}, norma_hypnotherapy.content
    assert_match %r{With me, it's better}, norma_hypnotherapy.content
    # assert_equal "With me, it's better", norma_hypnotherapy.content1_with
    assert !norma.tabs.map(&:title).include?(old_title), "Tabs should not contain #{old_title} anymore. Tabs are: #{norma.tabs.inspect}"
    assert norma.tabs.map(&:title).include?(yoga.name)
    norma.subcategories.reload
    assert norma.subcategories.include?(yoga), "Yoga should have been added to Norma's profile, as it was selected for a tab, subcategories were: #{norma.subcategories.map(&:name).to_sentence}"
    assert !norma.subcategories.include?(hypnotherapy), "Hypnotherapy should have been removed from Norma's profile, as it was removed as a tab, subcategories were: #{norma.subcategories.map(&:name).to_sentence}"    
  end

  def test_destroy_last_tab
    cyrille = users(:cyrille)
    cyrille_hypnotherapy = tabs(:cyrille_hypnotherapy)
    assert_equal 1, cyrille.tabs.size
    post :destroy, {:id => cyrille_hypnotherapy.slug}, {:user_id => cyrille.id }
    assert_not_nil flash[:error]
    assert_equal "You cannot delete your last tab", flash[:error]
    cyrille.reload
    assert_equal 1, cyrille.tabs.size, "The last tab should not be deleted"
    assert_redirected_to expanded_user_url(cyrille)
  end

  def test_destroy
    sgardiner = users(:sgardiner)
    sgardiner_life_coaching = tabs(:sgardiner_life_coaching)
    assert sgardiner.tabs.size > 1, "Should have more than 1 tab, otherwise it can't be deleted"
    old_size = sgardiner.tabs.size
    old_sub_size = sgardiner.subcategories.size
    post :destroy, {:id => sgardiner_life_coaching.slug}, {:user_id => sgardiner.id }
    assert_redirected_to expanded_user_url(sgardiner)
    assert_nil flash[:error]
    assert_not_nil flash[:notice]
    assert_equal "Your tab was deleted", flash[:notice]
    sgardiner.reload
    assert_equal old_size-1, sgardiner.tabs.size, "One tab should have been deleted"
    assert_equal old_sub_size-1, sgardiner.subcategories.size, "One subcategory should have been deleted"
  end

  def test_destroy_with_capitals
    sgardiner = users(:sgardiner)
    nlp = subcategories(:neuro_linguistic_programming)
    sgardiner_life_coaching = tabs(:sgardiner_life_coaching)
    sgardiner.remove_tab(sgardiner_life_coaching.slug)
    sgardiner.reload
    original_tab_size = sgardiner.tabs.size
    sgardiner.add_tab(nlp)
    sgardiner.reload
    assert_equal original_tab_size+1, sgardiner.tabs.size
    assert sgardiner.tabs.size > 1, "Should have more than 1 tab, otherwise it can't be deleted"
    old_sub_size = sgardiner.subcategories.size
    post :destroy, {:id => nlp.name.parameterize}, {:user_id => sgardiner.id }
    assert_redirected_to expanded_user_url(sgardiner)
    assert_nil flash[:error]
    assert_not_nil flash[:notice]
    assert_equal "Your tab was deleted", flash[:notice]
    sgardiner.reload
    assert_equal original_tab_size, sgardiner.tabs.size, "One tab should have been deleted"
    assert_equal old_sub_size-1, sgardiner.subcategories.size, "One subcategory should have been deleted"
  end

end
