require File.dirname(__FILE__) + '/../test_helper'

class ArticlesControllerTest < ActionController::TestCase
	fixtures :all
	
	def test_publish
		yoga = articles(:yoga)
		cyrille = users(:cyrille)
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

		post :publish, {:id => yoga.id }, {:user_id => cyrille.id}
		assert_redirected_to root_url
		yoga.reload
		assert_not_nil yoga.published_at

		#an email should be sent to reviewers
		assert ActionMailer::Base.deliveries.size > 0
	end

	def test_edit
		yoga = articles(:yoga)
		yoga_sub = subcategories(:yoga)
		cyrille = users(:cyrille)
		get :edit, {:id => "#{yoga.id}-blabla" }, {:user_id => cyrille.id}
		assert_response :success
		assert_select "select#article_subcategory1_id > option[value=#{yoga_sub.id}][selected=selected]"
	end

  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:articles)
  end

  def test_should_get_index_while_logged_in
		cyrille = users(:cyrille)
    get :index, {}, {:user_id => cyrille.id }
    assert_response :success
    assert_not_nil assigns(:articles)
		#User cyrille is logged and his default location should be selected
		assert_select "select#where > option[value=#{cyrille.district_id}][selected=selected]"
  end

  def test_should_get_new
		cyrille = users(:cyrille)
    get :new, {}, {:user_id => cyrille.id }
    assert_response :success
  end

  def test_should_create_article
		cyrille = users(:cyrille)
		yoga = subcategories(:yoga)
    assert_difference('Article.count') do
      post :create, {:article => { :title => "Test9992323", :subcategory1_id => yoga.id  }}, {:user_id => cyrille.id }
    end

    assert_redirected_to article_path(assigns(:article))
		assert_equal yoga.id, assigns(:article).subcategory1_id
  end

  def test_should_show_article
    get :show, :id => articles(:yoga).id
    assert_response :success
  end

  def test_should_get_edit
		cyrille = users(:cyrille)
    get :edit, {:id => "#{articles(:yoga).id}-blabla"}, {:user_id => cyrille.id }
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
