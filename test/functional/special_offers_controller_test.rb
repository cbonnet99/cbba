require File.dirname(__FILE__) + '/../test_helper'

class SpecialOffersControllerTest < ActionController::TestCase

  def test_index_for_subcategory_per_country
    subcat = Factory(:subcategory)
    nz = countries(:nz)
    au = countries(:au)
    gv_nz = Factory(:special_offer, :country => nz, :state => "published", :subcategory => subcat)
    gv_au = Factory(:special_offer, :country => au, :state => "published", :subcategory => subcat)
    
    get :index_for_subcategory, :subcategory_slug  => subcat.slug, :country_code => nz.country_code 
    
    assert !assigns(:special_offers).include?(gv_au), "Oz SO should not be displayed"
    assert assigns(:special_offers).include?(gv_nz), "NZ SO should be displayed"
  end

  def test_index_for_subcategory
    yoga = subcategories(:yoga)
    free_trial = special_offers(:free_trial)
    one = special_offers(:one)
    cyrille = users(:cyrille)
    new_so = Factory(:special_offer, :subcategory => yoga, :author => cyrille )
    new_so.publish!
    assert new_so.published?
    get :index_for_subcategory, :subcategory_slug  => yoga.slug
    # puts @response.body
    assert !assigns(:special_offers).include?(one), "Draft trial session should not be included in index_for_subcategory"
    assert assigns(:special_offers).include?(free_trial), "Published trial session should be included in index_for_subcategory"
    assert_equal new_so, assigns(:special_offers).first, "Latest trial session should appear first"
  end    
  
  def test_limit_special_offers_for_full_members
    sgardiner = users(:sgardiner)
    subcat = Factory(:subcategory)
    
    SpecialOffer.create(:title => "Title", :description => "Description", :state => "published", :author => sgardiner, :subcategory => subcat)

    new_offer2 = SpecialOffer.create(:title => "Title2", :description => "Description",
      :author => sgardiner, :subcategory => subcat)
    post :publish, {:id => new_offer2.id }, {:user_id => sgardiner.id }
    assert_equal "You have paid for 1 published trial session", flash[:error]
    assert_redirected_to special_offers_url
  end

  def test_limit_special_offers_for_resident_expert
    cyrille = users(:cyrille)
    one = special_offers(:one)
    subcat = Factory(:subcategory)

    SpecialOffer.create(:title => "Title", :description => "Description", :subcategory => subcat,
       :state => "published", :author => cyrille   )
    SpecialOffer.create(:title => "Title2", :description => "Description", :subcategory => subcat,
       :state => "published", :author => cyrille   )

    post :publish, {:id => one.id }, {:user_id => cyrille.id }
    assert_equal "You have paid for 3 published trial sessions", flash[:error]
    assert_redirected_to special_offers_url
  end

  def test_publish
    cyrille = users(:cyrille)
    one = special_offers(:one)
    old_published_count = cyrille.published_special_offers_count
    post :publish, {:id => one.id }, {:user_id => cyrille.id }
    assert_equal "\"#{one.title}\" successfully published", flash[:notice]
    assert_redirected_to special_offers_url
    cyrille.reload
    assert_equal old_published_count+1, cyrille.published_special_offers_count
  end

  def test_unpublish
    cyrille = users(:cyrille)
    free_trial = special_offers(:free_trial)
    old_published_count = cyrille.published_special_offers_count
    post :unpublish, {:id => free_trial.id }, {:user_id => cyrille.id }
    assert_redirected_to special_offers_url
    cyrille.reload
    assert_equal old_published_count-1, cyrille.published_special_offers_count
  end

  def test_create_with_error
    cyrille = users(:cyrille)
    old_count = cyrille.special_offers_count
    old_size = cyrille.special_offers.size
    post :create, {:special_offer => {:title => "Title", :description => "a"*601,
      } }, {:user_id => cyrille.id }
    new_offer = assigns(:special_offer)
    assert_not_nil new_offer
    assert !new_offer.errors.blank?, "Errors found in new_offer: #{new_offer.errors.inspect}"
    cyrille.reload
    assert_equal old_size, cyrille.special_offers.size
    assert_equal old_count, cyrille.special_offers_count
  end

  def test_create
    cyrille = users(:cyrille)
    old_count = cyrille.special_offers_count
    old_size = cyrille.special_offers.size
    subcat = Factory(:subcategory)
    
    post :create, {:special_offer => {:title => "Title", :description => "Description", :subcategory => subcat, 
      } }, {:user_id => cyrille.id }
      
    new_offer = assigns(:special_offer)
    assert_not_nil new_offer
    assert new_offer.errors.blank?, "Errors found in new_offer: #{new_offer.errors.inspect}"
    cyrille.reload
    assert_equal old_size+1, cyrille.special_offers.size
    assert_equal old_count+1, cyrille.special_offers_count
  end

  def test_update
    free_trial = special_offers(:free_trial)
    cyrille = users(:cyrille)
    post :update, {:id => free_trial.slug, :special_offer => {:title => "TitleNEW"} }, {:user_id => cyrille.id }
    new_offer = assigns(:special_offer)
    assert_not_nil new_offer
    assert new_offer.errors.blank?, "Errors found in new_offer: #{new_offer.errors.inspect}"
  end

  def test_update_errors
    free_trial = special_offers(:free_trial)
    cyrille = users(:cyrille)
    post :update, {:id => free_trial.slug, :special_offer => {:title => "TitleNEW", :description => "a"*620 } }, {:user_id => cyrille.id }
    new_offer = assigns(:special_offer)
    assert_not_nil new_offer
    assert !new_offer.errors.blank?
  end

  def test_index
    cyrille = users(:cyrille)
    get :index, {}, {:user_id => cyrille.id }
    assert_template 'index'
  end
  
  def test_show_profile
    cyrille = users(:cyrille)
    get :show, {:id => special_offers(:free_trial).slug, :selected_user => cyrille.slug, :context => "profile"}
    assert_template 'show'
    assert_select "a[href$=offers]", {:text => "Back to #{cyrille.name}'s profile", :count => 1  }
  end
  
  def test_show_published_not_approved
    cyrille = users(:cyrille)
    rmoore = users(:rmoore)
    get :show, {:id => special_offers(:published_not_approved).slug, :selected_user => rmoore.slug}, {:user_id => cyrille.id }
    assert_template 'show'
    assert_select "div[class=publication-actions]", :count => 1
  end
  
  def test_show_published_and_approved
    cyrille = users(:cyrille)
    rmoore = users(:rmoore)
    get :show, {:context => "profile", :id => special_offers(:published_and_approved).slug, :selected_user => rmoore.slug}, {:user_id => cyrille.id }
    assert_template 'show'
    assert_select "div[class=publication-actions]", :count => 0
    #rmoore's profile is in draft: a link back to his profile should not be provided
    assert_select "a[href$=offers]", {:text => "Back to #{rmoore.name}'s profile", :count => 0  }
  end
  
  def test_show_rejected
    cyrille = users(:cyrille)
    rmoore = users(:rmoore)
    get :show, {:id => special_offers(:rejected).slug, :selected_user => rmoore.slug}, {:user_id => cyrille.id }
    assert_template 'show'
    assert_select "div[class=publication-actions]", :count => 1
  end
    
  def test_show_draft
    cyrille = users(:cyrille)
    get :show, {:id => special_offers(:one).slug, :selected_user => cyrille.slug }
    assert_template ''
  end
  
  def test_show_draft_logged_in
    cyrille = users(:cyrille)
    get :show, {:id => special_offers(:one).slug, :selected_user => cyrille.slug }, {:user_id => cyrille.id }
    assert_template 'show'
  end
  
  def test_new
    get :new, {}, {:user_id => users(:cyrille).id }
    assert_template 'new'
  end
      
  def test_edit
    get :edit, {:id => special_offers(:one).slug}, {:user_id => users(:cyrille).id }
    assert_template 'edit'
  end
    
  def test_destroy
    special_offer = special_offers(:one)
    delete :destroy, {:id => special_offer.slug}, {:user_id => users(:cyrille).id }
    assert_redirected_to special_offers_url
    assert !SpecialOffer.exists?(special_offer.id)
  end
end
