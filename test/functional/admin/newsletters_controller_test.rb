require File.dirname(__FILE__) + '/../../test_helper'

class Admin::NewslettersControllerTest < ActionController::TestCase
  def test_index
    get :index, {}, {:user_id => users(:cyrille).id }
    assert_response :success
  end
  
  def test_show
    get :show, {:id => newsletters(:may_published).id }, {:user_id => users(:cyrille).id }
    assert_response :success
    assert_not_nil assigns(:newsletter)
  end
  
  def test_delete
    june_draft = newsletters(:june_draft)
    cyrille = users(:cyrille)
    newsletters_count = Newsletter.count
    post :delete, {:id => june_draft.id }, {:user_id => cyrille.id }
    assert_redirected_to newsletters_path
    assert_equal "Newsletter deleted", flash[:notice]
    assert_equal newsletters_count-1, Newsletter.count
  end
  
  def test_publish
    june_draft = newsletters(:june_draft)
    cyrille = users(:cyrille)
    post :publish, {:id => june_draft.id }, {:user_id => cyrille.id }
    assert_redirected_to newsletters_path
    assert_equal "Newsletter published", flash[:notice]
    june_draft.reload
    assert_equal cyrille, june_draft.publisher
    assert_not_nil june_draft.published_at
  end
  
  def test_retract
    may_published = newsletters(:may_published)
    cyrille = users(:cyrille)
    post :retract, {:id => may_published.id }, {:user_id => cyrille.id }
    assert_redirected_to newsletters_path
    may_published.reload
    assert_equal "Newsletter unpublished", flash[:notice]
    assert_nil may_published.publisher
    assert_nil may_published.published_at
  end
end
