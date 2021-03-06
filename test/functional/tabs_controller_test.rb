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
    hypnotherapy = subcategories(:hypnotherapy)
    sgardiner_hypnotherapy = tabs(:sgardiner_hypnotherapy)
    other_subcats_for_sgardiner = sgardiner.subcategories.reject{|s| s == hypnotherapy}
    assert !other_subcats_for_sgardiner.blank?
    
    get :edit, {:id => sgardiner_hypnotherapy.slug }, {:user_id => sgardiner.id }
    assert_response :success
    assert_select "input[name='tab[old_subcategory_id]']"
    assert_select "select#tab_subcategory_id option[value=#{hypnotherapy.id}][selected=selected]"
    
    assert assigns(:subcategories).include?([hypnotherapy.full_name, hypnotherapy.id]), "Subcategories are: #{assigns(:subcategories).to_sentence}"
    other_subcats_for_sgardiner.each do |s|
      assert !assigns(:subcategories).include?([s.full_name, s.id]), "Other subcategories for this user should not be selectable (otherwise, it will lead to errors on save)"
    end
  end
  
  def test_edit_unknown_slug
    sgardiner = users(:sgardiner)
    sgardiner_hypnotherapy = tabs(:sgardiner_hypnotherapy)
    get :edit, {:id => "blabla" }, {:user_id => sgardiner.id }
    assert_response :success
    assert_select "input[name='tab[old_subcategory_id]']"
  end
  
  def test_create_too_many
    rmoore = users(:rmoore)
    aromatherapy = subcategories(:aromatherapy)
    astrology = subcategories(:astrology)
    old_size = rmoore.subcategories.size
    rmoore.tabs.create(:subcategory_id => aromatherapy.id, :content => "My content" )
    rmoore.reload
    assert_equal old_size+1, rmoore.subcategories.size
    rmoore.tabs.reload
    post :create, { :subcategory_id => astrology.id, :content => "My content"}, {:user_id => rmoore.id }
    assert_nil assigns(:selected_tab)
    assert "Sorry, you can only have 3 tabs", flash[:error]
  end

 def test_create
   rmoore = users(:rmoore)
   astrology = subcategories(:astrology)
   old_size = rmoore.subcategories.size
   post :create, { :tab => {:subcategory_id => astrology.id, :content3_training=>Tab::DEFAULT_CONTENT3_TRAINING,
       :old_subcategory_id=>nil,:content2_benefits=>Tab::DEFAULT_CONTENT2_BENEFITS,
       :content1_with=>Tab::DEFAULT_CONTENT1_WITH,
       :content4_about=>Tab::DEFAULT_CONTENT4_ABOUT}}, {:user_id => rmoore.id }
   
   assert_nil flash[:error]
   assert_not_nil assigns(:selected_tab)
   assert_match %r{#{astrology.name} with #{rmoore.name}}, assigns(:selected_tab).content
   assert_equal astrology.name, assigns(:selected_tab).title
    
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
    subcat = Factory(:subcategory)
    post :create, {:tab => {:subcategory_id => subcat.id, :content => "this is a new tab"} }, {:user_id => cyrille.id }
    assert_not_nil assigns(:selected_tab)
    assert_equal 0, assigns(:selected_tab).errors.size, "There are errors: #{assigns(:selected_tab).errors.full_messages.to_sentence}"
    assert_equal old_size+1, Tab.all.size
    post :destroy, {:id => assigns(:selected_tab).slug }, {:user_id => cyrille.id }
    assert_equal old_size, Tab.all.size
  end

  def test_update
    norma = users(:norma)
    norma_hypnotherapy = tabs(:norma_hypnotherapy)
    hypnotherapy = subcategories(:hypnotherapy)
    yoga = subcategories(:yoga)
    assert !norma.subcategories.include?(yoga)
    old_subcategory_id = norma_hypnotherapy.subcategory_id
    post :update, {:id => norma_hypnotherapy.slug, :tab => {:old_subcategory_id => old_subcategory_id, :subcategory_id => yoga.id, :content1_with => "With me, it's better",
      :content2_benefits => "You'll be relaxed", :content3_training => "MBA with Harvard", :content4_about => "I love kitesurfing"  } }, {:user_id => norma.id }
    norma.reload
    norma.tabs.reload
    norma_hypnotherapy.reload
    assert_equal yoga.name, norma_hypnotherapy.title
    assert_match /MBA with Harvard/, norma_hypnotherapy.content
    assert !norma.tabs.map(&:subcategory_id).include?(old_subcategory_id), "Tabs should not contain #{old_subcategory_id} anymore. Tabs are: #{norma.tabs.inspect}"
    assert norma.tabs.map(&:title).include?(yoga.name)
    norma.subcategories.reload
    assert norma.subcategories.include?(yoga), "Yoga should have been added to Norma's profile, as it was selected for a tab, subcategories were: #{norma.subcategories.map(&:name).to_sentence}"
    assert !norma.subcategories.include?(hypnotherapy), "Hypnotherapy should have been removed from Norma's profile, as it was removed as a tab, subcategories were: #{norma.subcategories.map(&:name).to_sentence}"
  end

  def test_update_with_errors
    subcat = Factory(:subcategory)
    user = Factory(:user, :subcategory1_id => subcat.id)
    first_tab = user.tabs.first
    
    post :update, {:id => first_tab.slug, :tab => {:old_subcategory_id => first_tab.subcategory_id, :subcategory_id => nil, :content1_with => "With me, it's better",
      :content2_benefits => "You'll be relaxed", :content3_training => "MBA with Harvard", :content4_about => "I love kitesurfing"  } }, {:user_id => user.id }
    
    assert_response :success
    assert !assigns(:subcategories).blank?
  end

  def test_update_legacy
    norma = users(:norma)
    norma_hypnotherapy = tabs(:norma_hypnotherapy)
    hypnotherapy = subcategories(:hypnotherapy)
    yoga = subcategories(:yoga)
    assert !norma.subcategories.include?(yoga)
    old_subcategory_id = norma_hypnotherapy.subcategory_id
    post :update, {:id => norma_hypnotherapy.slug, :tab => {:old_subcategory_id => old_subcategory_id, :subcategory_id => yoga.id, :content => "SOMETHING that existed before",  :content1_with => "With me, it's better",
      :content2_benefits => "You'll be relaxed", :content3_training => "MBA with Harvard", :content4_about => "I love kitesurfing"  } }, {:user_id => norma.id }
    norma.reload
    norma.tabs.reload
    norma_hypnotherapy.reload
    assert_equal yoga.name, norma_hypnotherapy.title
    assert_no_match /SOMETHING that existed before/, norma_hypnotherapy.content
    assert_match /MBA with Harvard/, norma_hypnotherapy.content
    assert !norma.tabs.map(&:subcategory_id).include?(old_subcategory_id), "Tabs should not contain #{old_subcategory_id} anymore. Tabs are: #{norma.tabs.inspect}"
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
    old_subcategory_id = norma_hypnotherapy.subcategory_id
    post :update, {:id => norma_hypnotherapy.slug, :tab => {:old_subcategory_id => old_subcategory_id, :subcategory_id => yoga.id, :content1_with => "With me, it's better",
      :content2_benefits => "You'll be <h2>relaxed</h2>", :content3_training => "MBA with Harvard", :content4_about => "I love kitesurfing"  } }, {:user_id => norma.id }
    norma.reload
    norma.tabs.reload
    norma_hypnotherapy.reload
    assert_equal yoga.name, norma_hypnotherapy.title
    assert_match %r{You'll be relaxed}, norma_hypnotherapy.content
    assert_match %r{With me, it's better}, norma_hypnotherapy.content
    # assert_equal "With me, it's better", norma_hypnotherapy.content1_with
    assert !norma.tabs.map(&:subcategory_id).include?(old_subcategory_id), "Tabs should not contain #{old_subcategory_id} anymore. Tabs are: #{norma.tabs.inspect}"
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
