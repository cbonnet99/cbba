require File.dirname(__FILE__) + '/../test_helper'

class ArticlesControllerTest < ActionController::TestCase
  include ApplicationHelper
  
	fixtures :all
	
	def test_unpublish
		long = articles(:long)
		cyrille = users(:cyrille)
    old_published_count = cyrille.published_articles_count
		post :unpublish, {:id => long.id }, {:user_id => cyrille.id}
		assert_redirected_to root_url
		long.reload
    assert long.draft?
		assert_nil long.published_at
    cyrille.reload
    assert_equal old_published_count-1, cyrille.articles.published.size
    assert_equal old_published_count-1, cyrille.published_articles_count

  end
	def test_publish
		yoga = articles(:yoga)
		cyrille = users(:cyrille)
    old_published_count = cyrille.published_articles_count
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

		post :publish, {:id => yoga.id }, {:user_id => cyrille.id}
		assert_redirected_to root_url
		yoga.reload
		assert_not_nil yoga.published_at

		#an email should be sent to reviewers
		assert ActionMailer::Base.deliveries.size > 0
    
    cyrille.reload
    assert_equal old_published_count+1, cyrille.published_articles_count
	end

	def test_edit
		yoga = articles(:yoga)
		yoga_sub = subcategories(:yoga)
		cyrille = users(:cyrille)
		get :edit, {:id => yoga.id }, {:user_id => cyrille.id}
		assert_response :success
		assert_select "select#article_subcategory1_id > option[value=#{yoga_sub.id}][selected=selected]"
	end

  def test_should_get_index_for_subcategory
    get :index_for_subcategory, :subcategory_slug => subcategories(:yoga).slug 
    assert_response :success
    assert_not_nil assigns(:articles)
  end
  
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:articles)
  end

  def test_should_get_new
		cyrille = users(:cyrille)
    get :new, {}, {:user_id => cyrille.id }
    assert_response :success
    #should default to the user's main expertise
		assert_select "select#article_subcategory1_id > option[value=#{cyrille.subcategories.first.id}][selected=selected]"
  end

  def test_should_create_article
		cyrille = users(:cyrille)
		yoga = subcategories(:yoga)
    old_count = cyrille.articles_count
    post :create, {:article => { :title => "Test9992323", :lead => "Test9992323", :body => "",  :subcategory1_id => yoga.id }}, {:user_id => cyrille.id }
    assert_redirected_to articles_show_path(assigns(:article).author.slug, assigns(:article).slug)
		assert_equal yoga.id, assigns(:article).subcategory1_id
    assert_not_nil assigns(:subcategories)
    cyrille.reload
    assert_equal old_count+1, cyrille.articles_count

  end

  def test_should_create_article_lead_too_long
		cyrille = users(:cyrille)
		yoga = subcategories(:yoga)
    old_count = cyrille.articles_count
    post :create, {:article => { :title => "Test9992323", :lead => "T"*501, :body => "",  :subcategory1_id => yoga.id }}, {:user_id => cyrille.id }
    assert_not_nil assigns(:article)
    assert !assigns(:article).errors.blank?
    cyrille.reload
    assert_equal old_count, cyrille.articles_count

  end

  def test_should_show_article_review
    cyrille = users(:cyrille)
    rmoore = users(:rmoore)
    #jogging is a published article that hasn't been approved yet
    get :show, {:id => articles(:jogging).slug, :selected_user => rmoore.slug, :review => "true"  }, {:user_id => cyrille.id }
    assert flash[:error].blank?, "flash[:error] is #{flash[:error]}"
    assert_response :success
    assert_not_nil assigns(:selected_user)
    assert_not_nil assigns(:article)
    #cyrille is a reviewer
    assert_select "input[value=Approve]"
    assert_select "a", {:text => "Back to your articles", :count => 0  }
    assert_select "a", {:text => "Back to review list", :count => 1  }
  end

  def test_should_show_article_draft_anonymous
    cyrille = users(:cyrille)
    get :show, {:id => articles(:yoga).slug, :selected_user => cyrille.slug }
    assert_redirected_to articles_path
    assert_not_nil assigns(:selected_user)
    assert_nil assigns(:article)
  end

  def test_should_show_own_article_draft
      cyrille = users(:cyrille)
      get :show, {:id => articles(:yoga).slug, :selected_user => cyrille.slug }, {:user_id => cyrille.id }
      assert_response :success
      assert_not_nil assigns(:selected_user)
      assert_not_nil assigns(:article)
  end

  def test_should_get_edit
		cyrille = users(:cyrille)
    get :edit, {:id => articles(:yoga).id, :selected_user => cyrille.slug}, {:user_id => cyrille.id }
    assert_response :success
  end

  def test_should_update_article
		cyrille = users(:cyrille)
    put :update, {:id => articles(:yoga).id, :article => { }}, {:user_id => cyrille.id }
    assert_redirected_to articles_show_path(assigns(:article).author.slug, assigns(:article).slug)
    assert_not_nil assigns(:subcategories)
  end

  def test_should_destroy_article
		cyrille = users(:cyrille)
    assert_difference('Article.count', -1) do
      delete :destroy, {:id => articles(:yoga).id}, {:user_id => cyrille.id }
    end

    assert_redirected_to user_articles_path
  end
end
