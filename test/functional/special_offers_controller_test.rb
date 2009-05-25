require File.dirname(__FILE__) + '/../test_helper'

class SpecialOffersControllerTest < ActionController::TestCase

  def test_index_public
    get :index_public
  end

  def test_limit_special_offers_for_full_members
    sgardiner = users(:sgardiner)

    SpecialOffer.create(:title => "Title", :description => "Description",
      :how_to_book => "Book here", :terms => "Terms here", :state => "published", :author => sgardiner   )

    new_offer2 = SpecialOffer.create(:title => "Title2", :description => "Description",
      :how_to_book => "Book here", :terms => "Terms here", :author => sgardiner)
    post :publish, {:id => new_offer2.id }, {:user_id => sgardiner.id }
    assert_equal "You can only have 1 special offer published at any time", flash[:error]
    assert_redirected_to special_offer_path(new_offer2)
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
    assert_redirected_to special_offer_path(one)
  end

  def test_publish
    cyrille = users(:cyrille)
    one = special_offers(:one)
    old_published_count = cyrille.published_special_offers_count
    post :publish, {:id => one.id }, {:user_id => cyrille.id }
    assert_equal "Special offer successfully published", flash[:notice]
    assert_redirected_to special_offer_path(one)
    cyrille.reload
    assert_equal old_published_count+1, cyrille.published_special_offers_count
  end

  def test_unpublish
    cyrille = users(:cyrille)
    free_trial = special_offers(:free_trial)
    old_published_count = cyrille.published_special_offers_count
    post :unpublish, {:id => free_trial.id }, {:user_id => cyrille.id }
    assert_redirected_to special_offer_path(free_trial)
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

    #delete special offers directory
    FileUtils.rm_rf(SpecialOffer::PDF_SUFFIX_ABSOLUTE+SpecialOffer::PDF_SUFFIX_RELATIVE)
  end

  def test_update
    free_trial = special_offers(:free_trial)
    cyrille = users(:cyrille)
    post :update, {:id => free_trial.slug, :special_offer => {:title => "TitleNEW"} }, {:user_id => cyrille.id }
    new_offer = assigns(:special_offer)
    assert_not_nil new_offer
    assert new_offer.errors.blank?, "Errors found in new_offer: #{new_offer.errors.inspect}"

    #delete special offers directory
    FileUtils.rm_rf(SpecialOffer::PDF_SUFFIX_ABSOLUTE+SpecialOffer::PDF_SUFFIX_RELATIVE)
  end

  def test_index
    cyrille = users(:cyrille)
    get :index, {}, {:user_id => cyrille.id }
    assert_template 'index'
  end
  
  def test_show
    get :show, {:id => special_offers(:one).slug}, {:user_id => users(:cyrille).id }
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
