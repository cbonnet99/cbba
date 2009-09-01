require File.dirname(__FILE__) + '/../test_helper'

class SpecialOffersControllerTest < ActionController::TestCase

  def teardown
    FileUtils.rm_rf(SpecialOffer::PDF_SUFFIX_ABSOLUTE+SpecialOffer::PDF_SUFFIX_RELATIVE)
  end

  def test_index_for_subcategory
    yoga = subcategories(:yoga)
    free_trial = special_offers(:free_trial)
    one = special_offers(:one)
    get :index_for_subcategory, :subcategory_slug  => yoga.slug
    # puts @response.body
    assert !assigns(:special_offers).include?(one), "Draft special offer should not be included in index_for_subcategory"
    assert assigns(:special_offers).include?(free_trial), "Published special offer should be included in index_for_subcategory"
  end    
  
  def test_limit_special_offers_for_full_members
    sgardiner = users(:sgardiner)

    SpecialOffer.create(:title => "Title", :description => "Description",
      :how_to_book => "Book here", :terms => "Terms here", :state => "published", :author => sgardiner   )

    new_offer2 = SpecialOffer.create(:title => "Title2", :description => "Description",
      :how_to_book => "Book here", :terms => "Terms here", :author => sgardiner)
    post :publish, {:id => new_offer2.id }, {:user_id => sgardiner.id }
    assert_equal "You can only have 1 special offer published at any time", flash[:error]
    assert_redirected_to special_offers_show_path(new_offer2.author.slug, new_offer2.slug)
  end

  def test_limit_special_offers_for_resident_expert
    cyrille = users(:cyrille)
    one = special_offers(:one)

    SpecialOffer.create(:title => "Title", :description => "Description",
      :how_to_book => "Book here", :terms => "Terms here", :state => "published", :author => cyrille   )
    SpecialOffer.create(:title => "Title2", :description => "Description",
      :how_to_book => "Book here", :terms => "Terms here", :state => "published", :author => cyrille   )

    post :publish, {:id => one.id }, {:user_id => cyrille.id }
    assert_equal "You can only have 3 special offers published at any time", flash[:error]
    assert_redirected_to special_offers_show_path(one.author.slug, one.slug)
  end

  def test_publish
    cyrille = users(:cyrille)
    one = special_offers(:one)
    old_published_count = cyrille.published_special_offers_count
    post :publish, {:id => one.id }, {:user_id => cyrille.id }
    assert_equal "Special offer successfully published", flash[:notice]
    assert_redirected_to special_offers_show_path(one.author.slug, one.slug)
    cyrille.reload
    assert_equal old_published_count+1, cyrille.published_special_offers_count
  end

  def test_unpublish
    cyrille = users(:cyrille)
    free_trial = special_offers(:free_trial)
    old_published_count = cyrille.published_special_offers_count
    post :unpublish, {:id => free_trial.id }, {:user_id => cyrille.id }
    assert_redirected_to special_offers_show_path(free_trial.author.slug, free_trial.slug)
    cyrille.reload
    assert_equal old_published_count-1, cyrille.published_special_offers_count
  end

  def test_create
    cyrille = users(:cyrille)
    old_count = cyrille.special_offers_count
    old_size = cyrille.special_offers.size
    post :create, {:special_offer => {:title => "Title", :description => "Description",
      :how_to_book => "Book here", :terms => "Terms here"} }, {:user_id => cyrille.id }
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

  def test_index
    cyrille = users(:cyrille)
    get :index, {}, {:user_id => cyrille.id }
    assert_template 'index'
  end
  
  def test_show
    cyrille = users(:cyrille)
    get :show, {:id => special_offers(:free_trial).slug, :selected_user => cyrille.slug }
    assert_template 'show'
  end
  
  def test_show_pdf
    cyrille = users(:cyrille)
    free_trial = special_offers(:free_trial)
    #save the offer so that the PDF is created
    free_trial.save!
    get :show, {:id => free_trial.slug, :selected_user => cyrille.slug, :format => "pdf"  }
    assert_response :success
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
