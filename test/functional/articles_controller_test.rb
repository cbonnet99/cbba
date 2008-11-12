require File.dirname(__FILE__) + '/../test_helper'

class ArticlesControllerTest < ActionController::TestCase
	fixtures :all
	
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:articles)
  end

  def test_should_get_new
		cyrille = users(:cyrille)
    get :new, {}, {:user_id => cyrille.id }
    assert_response :success
  end

  def test_should_create_article
		cyrille = users(:cyrille)
    assert_difference('Article.count') do
      post :create, {:article => { :title => "Test" }}, {:user_id => cyrille }
    end

    assert_redirected_to article_path(assigns(:article))
  end

  def test_should_show_article
    get :show, :id => articles(:yoga).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => articles(:yoga).id
    assert_response :success
  end

  def test_should_update_article
    put :update, :id => articles(:yoga).id, :article => { }
    assert_redirected_to article_path(assigns(:article))
  end

  def test_should_destroy_article
		cyrille = users(:cyrille)
    assert_difference('Article.count', -1) do
      delete :destroy, {:id => articles(:yoga).id}, {:user_id => cyrille.id }
    end

    assert_redirected_to articles_path
  end
end
