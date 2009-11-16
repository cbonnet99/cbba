require File.dirname(__FILE__) + '/../../test_helper'

class Admin::NewslettersControllerTest < ActionController::TestCase
  
  def test_new
    get :new, {}, {:user_id => users(:cyrille).id }
    assert_response :success
    assert_equal 4, assigns(:special_offers).size
    assert !assigns(:articles).include?(articles(:rejected))
    assert_select "input[class=special_offer_checkbox]", :count => 4 
    assert_select "input[class=special_offer_checkbox][checked=checked]", :count => 3 
  end

  def test_create
    free_trial = special_offers(:free_trial)
    post :create, {:newsletter => {:title => "bla", :special_offers_attributes => {:id => free_trial.id } } }, {:user_id => users(:cyrille).id }
    assert_redirected_to admin_newsletters_url
    assert_not_nil assigns(:newsletter)
    assert assigns(:newsletter).errors.blank?
    assert_equal [free_trial], assigns(:newsletter).special_offers
  end
  
  def test_edit
    get :edit, {:id => newsletters(:may_published).id }, {:user_id => users(:cyrille).id }
    assert_response :success
    assert_equal 4, assigns(:special_offers).size
    assert_select "input[class=special_offer_checkbox]", :count => 4
    assert_select "input[class=special_offer_checkbox][checked=checked]", :count => 1
  end
  
  def test_update
    free_trial = special_offers(:free_trial)
    may_published = newsletters(:may_published)
    post :update, {:id => may_published.id, :newsletter => {:title => "bla", :special_offers_attributes => {:id => free_trial.id } } }, {:user_id => users(:cyrille).id }
    assert_redirected_to admin_newsletters_url
    may_published.reload
    assert assigns(:newsletter).errors.blank?
    assert_equal [free_trial], may_published.special_offers
    assert_equal "bla", may_published.title
  end
  
  def test_index
    get :index, {}, {:user_id => users(:cyrille).id }
    assert_response :success
  end
  
  def test_show
    get :show, {:id => newsletters(:may_published).id }, {:user_id => users(:cyrille).id }
    assert_response :success
    assert_not_nil assigns(:newsletter)
  end
  
  def test_destroy
    june_draft = newsletters(:june_draft)
    cyrille = users(:cyrille)
    newsletters_count = Newsletter.count
    post :destroy, {:id => june_draft.id }, {:user_id => cyrille.id }
    assert_redirected_to admin_newsletters_url
    assert_equal "Newsletter deleted", flash[:notice]
    assert_equal newsletters_count-1, Newsletter.count
  end
  
  def test_destroy_published
    may_published = newsletters(:may_published)
    cyrille = users(:cyrille)
    newsletters_count = Newsletter.count
    post :destroy, {:id => may_published.id }, {:user_id => cyrille.id }
    assert_redirected_to admin_newsletters_url
    assert_equal "Newsletter is published, you must unpublish it before deleting it", flash[:error]
    assert_equal newsletters_count, Newsletter.count
  end
  
  def test_publish
    june_draft = newsletters(:june_draft)
    cyrille = users(:cyrille)
    post :publish, {:id => june_draft.id }, {:user_id => cyrille.id }
    assert_redirected_to admin_newsletters_url
    assert_equal "Newsletter published", flash[:notice]
    june_draft.reload
    assert_equal cyrille, june_draft.publisher
    assert_not_nil june_draft.published_at
  end
  
  def test_retract
    may_published = newsletters(:may_published)
    cyrille = users(:cyrille)
    post :retract, {:id => may_published.id }, {:user_id => cyrille.id }
    assert_redirected_to admin_newsletters_url
    may_published.reload
    assert_equal "Newsletter unpublished", flash[:notice]
    assert_nil may_published.publisher
    assert_nil may_published.published_at
  end
end
