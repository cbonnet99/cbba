require File.dirname(__FILE__) + '/../test_helper'

class ArticlesControllerTest < ActionController::TestCase
  include ApplicationHelper
  
	fixtures :all

  def test_index_for_subcategory
    yoga = subcategories(:yoga)
    article_yoga = articles(:yoga)
    long = articles(:long)
    get :index_for_subcategory, :subcategory_slug  => yoga.slug
    assert assigns(:articles).include?(long), "Published article should be included in index_for_subcategory"
    assert !assigns(:articles).include?(article_yoga), "Draft article should not be included in index_for_subcategory"
  end

  def test_index_for_subcategory_nz
    yoga = subcategories(:yoga)
    au_article = Factory(:article, :country => countries(:au), :subcategory1_id => yoga.id, :author => users(:jones_au))
    nz = countries(:nz)
    article_yoga = articles(:yoga)
    long = articles(:long)
    get :index_for_subcategory, :subcategory_slug  => yoga.slug, :country_code => nz.country_code
    assert assigns(:articles).include?(long), "Published article should be included in index_for_subcategory"
    assert !assigns(:articles).include?(article_yoga), "Draft article should not be included in index_for_subcategory"
    assigns(:articles).each do |a|
      assert_equal nz, a.country, "For article #{a}, expected country: #{nz}, but got #{a.country}"
    end
  end

  def test_index_rss
    get :index, :format => "rss"
    assert_response :success
    assert_not_nil assigns(:all_articles)
    assert !assigns(:all_articles).blank?
    assigns(:all_articles).each do |a|
      if a.is_a?(Article)
        assert_select "link", :text => "#{articles_show_url(a.author.slug, a.slug)}"
      end
    end
  end
    
	
	def test_unpublish
	  TaskUtils.update_subcategories_counters
		long = articles(:long)
    subcat = long.subcategories.first
		cyrille = users(:cyrille)
    old_published_count = cyrille.published_articles_count
    old_country_count = CountriesSubcategory.find_by_country_id_and_subcategory_id(cyrille.country.id, subcat.id).try(:published_articles_count) || 0
    subcat = long.subcategories.first
    old_count = subcat.published_articles_count
		post :unpublish, {:context => "profile", :selected_tab_id => "articles", :id => long.id }, {:user_id => cyrille.id}
		assert_redirected_to expanded_user_url(cyrille, :selected_tab_id => "articles")
		long.reload
    assert long.draft?
		assert_nil long.published_at
    cyrille.reload
    assert_equal old_published_count-1, cyrille.articles.published.size
    assert_equal old_published_count-1, cyrille.published_articles_count
    subcat.reload
    assert_equal old_count-1, subcat.published_articles_count
    cs = CountriesSubcategory.find_by_country_id_and_subcategory_id(cyrille.country.id, subcat.id)
    assert_not_nil cs
    assert_equal old_country_count-1, cs.published_articles_count
  end
  
	def test_publish
	  TaskUtils.update_subcategories_counters
		yoga = articles(:yoga)
    subcat = yoga.subcategories.first
    old_count = subcat.published_articles_count
		cyrille = users(:cyrille)
    old_country_count = CountriesSubcategory.find_by_country_id_and_subcategory_id(cyrille.country.id, subcat.id).try(:published_articles_count) || 0
    old_published_count = cyrille.published_articles_count
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

		post :publish, {:context => "profile", :selected_tab_id => "articles", :id => yoga.id }, {:user_id => cyrille.id}
		assert_redirected_to expanded_user_url(cyrille, :selected_tab_id => "articles")
		yoga.reload
		assert_not_nil yoga.published_at

		#an email should be sent to reviewers
		assert ActionMailer::Base.deliveries.size > 0
    
    cyrille.reload
    assert_equal old_published_count+1, cyrille.published_articles_count
    subcat.reload
    assert_equal old_count+1, subcat.published_articles_count
    cs = CountriesSubcategory.find_by_country_id_and_subcategory_id(cyrille.country.id, subcat.id)
    assert_not_nil cs
    assert_equal old_country_count+1, cs.published_articles_count
	end

	def test_edit
		yoga = articles(:yoga)
		yoga_sub = subcategories(:yoga)
		cyrille = users(:cyrille)
		get :edit, {:id => yoga.slug }, {:user_id => cyrille.id}
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
    assert_not_nil assigns(:subcategories)
  end

  def test_should_get_index_nz
    au_article = Factory(:article, :country => countries(:au))
    
    get :index, :country_code => "nz" 
    assert_response :success
    assert_not_nil assigns(:subcategories)
    assert !assigns(:recent_articles).blank?
    nz = countries(:nz)
    assigns(:recent_articles).each do |a|
      assert_equal nz, a.country
    end
  end

  def test_should_get_new
		cyrille = users(:cyrille)
		user_about = "This is about me"
		cyrille.about = user_about
		cyrille.save!
		cyrille.reload
    get :new, {}, {:user_id => cyrille.id }
    assert_response :success
    #should default to the user's main expertise
		assert_select "select#article_subcategory1_id > option[value=#{cyrille.subcategories.first.id}][selected=selected]", true, "A default subcategory should be selected automatically"
		assert_select "textarea#article_about", true, "There should be an about section"
		assert_select "textarea#article_about", user_about, "There should be an about section with text from user about"
  end

  def test_should_create_article
		cyrille = users(:cyrille)
		yoga = subcategories(:yoga)
    old_count = cyrille.articles_count
    about = "And you can contact me"
    post :create, {:context => "profile", :selected_tab_id => "articles",  :article => {:about => about,  :title => "Test9992323", :lead => "Test9992323", :body => "",  :subcategory1_id => yoga.id }}, {:user_id => cyrille.id }
    assert_redirected_to articles_show_url(assigns(:article).author.slug, assigns(:article).slug, :context => "profile", :selected_tab_id => "articles")
		assert_equal yoga.id, assigns(:article).subcategory1_id
		assert_equal about, assigns(:article).about
		assert_equal countries(:nz), assigns(:article).country
    assert_not_nil assigns(:subcategories)
    cyrille.reload
    assert_equal about, cyrille.about, "About section should be saved for user (so that next time, the new about section is used)"
    assert_equal old_count+1, cyrille.articles_count
  end

  def test_should_create_article_and_send_congrats_email
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    
    user = Factory(:user)
		yoga = subcategories(:yoga)
    post :create, {:context => "profile", :selected_tab_id => "articles",  :article => { :title => "Test9992323", :lead => "Test9992323", :body => "",  :subcategory1_id => yoga.id }}, {:user_id => user.id }
    assert_redirected_to articles_show_url(assigns(:article).author.slug, assigns(:article).slug, :context => "profile", :selected_tab_id => "articles")
		assert_equal yoga.id, assigns(:article).subcategory1_id
    assert_not_nil assigns(:subcategories)
    user.reload
    assert_equal 1, user.articles_count
		assert_equal User.reviewers.size+1, ActionMailer::Base.deliveries.size, "An email should be sent to all reviewers and a congrat email should be sent to the user (as it is her first published article)"
    
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
    get :show, {:id => articles(:jogging).slug, :selected_user => rmoore.slug, :context => "review"  }, {:user_id => cyrille.id }
    assert flash[:error].blank?, "flash[:error] is #{flash[:error]}"
    assert_response :success
    assert_not_nil assigns(:selected_user)
    assert_not_nil assigns(:article)
    #cyrille is a reviewer
    assert_select "input[value=Approve]"
    assert_select "a", {:text => "Back to your articles", :count => 0  }
    assert_select "a", {:text => "Back to review list", :count => 1  }
    assert_select "div[class=publication-actions]", :count => 1
  end

  def test_should_show_article_draft_anonymous
    cyrille = users(:cyrille)
    get :show, {:id => articles(:yoga).slug, :selected_user => cyrille.slug }
    assert_redirected_to articles_url
    assert_not_nil assigns(:selected_user)
    assert_nil assigns(:article)
  end

  def test_should_show_article_published_anonymous
    cyrille = users(:cyrille)
    get :show, {:context => "homepage", :id => articles(:long).slug, :selected_user => cyrille.slug }
    assert_response :success
    assert_not_nil assigns(:selected_user)
    assert_not_nil assigns(:article)
    assert_select "a", {:text => "Back to articles", :count => 1  }
    assert_select "div[class=publication-actions]", :count => 0
  end

  def test_should_show_article_published_logged_in
    cyrille = users(:cyrille)
    rmoore = users(:rmoore)
    get :show, {:context => "homepage", :id => articles(:jogging).slug, :selected_user => rmoore.slug }, {:user_id => cyrille.id }
    assert_response :success
    assert_not_nil assigns(:selected_user)
    assert_not_nil assigns(:article)
    assert_select "a", {:text => "Back to articles", :count => 1  }
    #the article has not yet been approved
    assert_select "div[class=publication-actions]", :count => 1
  end

  def test_should_show_article_incorrect_article_id
    cyrille = users(:cyrille)
    get :show, {:context => "profile", :id => "blalbla", :selected_user => cyrille.slug }
    assert_redirected_to expanded_user_url(cyrille, :selected_tab_id => "articles")
    assert_not_nil assigns(:selected_user)
    assert_nil assigns(:article)
  end

  def test_should_show_article_incorrect_article_id_logged_in
    cyrille = users(:cyrille)
    get :show, {:context => "profile", :id => "blalbla", :selected_user => cyrille.slug }, {:user_id => users(:norma).id }
    assert_redirected_to expanded_user_url(cyrille, :selected_tab_id => "articles")
    assert_not_nil assigns(:selected_user)
    assert_nil assigns(:article)
  end

  def test_should_show_article_incorrect_author
    cyrille = users(:cyrille)
    get :show, {:context => "profile", :id => articles(:long).slug, :selected_user => "mlmlmlm" }
    assert_redirected_to articles_url
    assert_nil assigns(:selected_user)
    assert_nil assigns(:article)
  end

  def test_should_show_article_incorrect_author_logged_in
    cyrille = users(:cyrille)
    get :show, {:context => "profile", :id => articles(:long).slug, :selected_user => "mlmlmlm" }, {:user_id => users(:norma).id }
    assert_redirected_to articles_url
    assert_nil assigns(:selected_user)
    assert_nil assigns(:article)
  end

  def test_should_not_hyperlink_inactive_author
    user = Factory(:user, :state => "inactive" )
    article = Factory(:article, :author => user)
    assert article.published?
    get :show, {:id => article.slug, :selected_user => user.slug  }
    assert_response :success
    assert_select "a[href]", {:text => user.name, :count => 0 }
  end

  def test_should_show_article_profile
    long = articles(:long)
    old_count = long.view_counts
    old_monthly_count = long.monthly_view_counts
    cyrille = users(:cyrille)
    get :show, {:context => "profile", :id => long.slug, :selected_user => cyrille.slug }
    assert_response :success
    assert_not_nil assigns(:selected_user)
    assert_not_nil assigns(:article)
    assert_select "a[href$=articles]", {:text => "Back to #{cyrille.name}'s profile", :count => 1  }
    assert_select "div[class=publication-actions]", :count => 0
    long.reload
    assert_equal old_count+1, long.view_counts
    assert_equal old_monthly_count+1, long.monthly_view_counts
  end

  def test_should_show_own_article_draft
      cyrille = users(:cyrille)
      yoga = articles(:yoga)
      old_count = yoga.view_counts
      old_monthly_count = yoga.monthly_view_counts
      get :show, {:context => "profile", :selected_tab_id => "articles",  :id => yoga.slug, :selected_user => cyrille.slug }, {:user_id => cyrille.id }
      assert_response :success
      assert_not_nil assigns(:selected_user)
      assert_not_nil assigns(:article)
      assert_select "a", {:text => "Profile", :count => 1  }
      assert_select "div[class=publication-actions]", :count => 1
      yoga.reload
      assert_equal old_count+1, yoga.view_counts
      assert_equal old_monthly_count+1, yoga.monthly_view_counts
  end

  def test_should_get_edit
		cyrille = users(:cyrille)
    get :edit, {:id => articles(:yoga).slug, :selected_user => cyrille.slug}, {:user_id => cyrille.id }
    assert_response :success
  end

  def test_should_update_article
		cyrille = users(:cyrille)
    put :update, {:context => "profile", :selected_tab_id => "articles",  :id => articles(:yoga).slug, :article => { }}, {:user_id => cyrille.id }
    assert_redirected_to articles_show_url(assigns(:article).author.slug, assigns(:article).slug, :context => "profile", :selected_tab_id => "articles")
    assert_not_nil assigns(:subcategories)
  end

  def test_should_destroy_article
		cyrille = users(:cyrille)
    assert_difference('Article.count', -1) do
      delete :destroy, {:context => "profile", :selected_tab_id => "articles", :id => articles(:yoga).slug}, {:user_id => cyrille.id }
    end
    assert_redirected_to expanded_user_url(cyrille, :selected_tab_id => "articles")
  end
  def test_should_destroy_draft_article
		cyrille = users(:cyrille)
		old_size = cyrille.articles_count
    delete :destroy, {:context => "profile", :selected_tab_id => "articles", :id => articles(:yoga).slug}, {:user_id => cyrille.id }
    cyrille.reload
    assert_equal old_size-1, cyrille.articles_count
    assert_redirected_to expanded_user_url(cyrille, :selected_tab_id => "articles")
  end
  def test_should_destroy_published_article
		cyrille = users(:cyrille)
		old_size = cyrille.published_articles_count
    delete :destroy, {:context => "profile", :selected_tab_id => "articles", :id => articles(:long).slug}, {:user_id => cyrille.id }
    cyrille.reload
    assert_equal old_size-1, cyrille.published_articles_count
    assert_redirected_to expanded_user_url(cyrille, :selected_tab_id => "articles")
  end
end
