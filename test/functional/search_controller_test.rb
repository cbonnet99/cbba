require File.dirname(__FILE__) + '/../test_helper'

class SearchControllerTest < ActionController::TestCase
  fixtures :all
	include ApplicationHelper

  def test_main_rss
    get :main, {:format => "rss"}
    assert_response :success
  end

  def test_count_show_more_details
    old_count = UserEvent.free_users_show_details.size
    post :count_show_more_details, {:id => "bam-show-more-details-#{users(:rmoore).id}" }
    assert_response :success
    assert_equal old_count+1, UserEvent.free_users_show_details.size
  end

  def test_index
    jogging = articles(:jogging)
    cyrille = users(:cyrille)
    TaskUtils.rotate_users
    cyrille.reload
    yoga = subcategories(:yoga)
    get :index, :country_code => "nz"
    assert_equal "nz", assigns(:country).country_code
    assert_response :success
    #Create 4 more published articles
    test1 = Article.create(:title => "Test1", :lead => "Test1", :body => "",  :state => "published",
      :published_at => 3.days.ago, :author => cyrille, :subcategory1_id => yoga.id  )
    test2 = Article.create(:title => "Test2", :lead => "Test2", :body => "", :state => "published",
      :published_at => 3.days.ago, :author => cyrille, :subcategory1_id => yoga.id )
    test3 = Article.create(:title => "Test3", :lead => "Test1", :body => "",  :state => "published",
      :published_at => 3.days.ago, :author => cyrille, :subcategory1_id => yoga.id  )
    test4 = Article.create(:title => "Test4", :lead => "Test2", :body => "", :state => "published",
      :published_at => 3.days.ago, :author => cyrille, :subcategory1_id => yoga.id )
    get :index, :country_code => "nz"
    assert_equal "nz", assigns(:country).country_code
    assert_response :success
    #+1 for twitter widget
    assert_select "div.homepage-article", :maximum => Article::NUMBER_ON_HOMEPAGE+1
    assert_select "a", :text => "View more articles &raquo;"
    assert_equal 1, assigns(:featured_full_members).size
    assert Article::NUMBER_ON_HOMEPAGE >= assigns(:newest_articles).size
  end

  def test_search_full_member_full_name
    cyrille = users(:cyrille)
		get :search, :where => nil, :what => CGI::escape(cyrille.full_name)
    assert_not_nil assigns(:selected_user)
		assert_redirected_to expanded_user_url(cyrille, :where => "", :what => cyrille.full_name  )
  end
  
  def test_search_lowercase
		hypnotherapy = subcategories(:hypnotherapy)
		canterbury_christchurch_city = districts(:canterbury_christchurch_city)
		get :search, :where => canterbury_christchurch_city.name, :what => hypnotherapy.name.upcase, :country_code => "nz"
    assert_not_nil assigns(:subcategory)
    assert_response :success
    assert_equal 3, assigns(:results).size
  end

  def test_search_subcat_by_country
    subcat = Factory(:subcategory)
    nz = countries(:nz)
    au = countries(:au)
    nz_user = Factory(:user, :country => nz, :subcategory1_id => subcat.id)
    au_user = Factory(:user, :country => au, :subcategory1_id => subcat.id)
    
    get :search, :where => "", :what => subcat.name, :country_code => "nz"
    
    assert_redirected_to subcategory_url(subcat.category.slug, subcat.slug)
    assert assigns(:results).include?(nz_user) 
    assert !assigns(:results).include?(au_user) 
  end
  
  def test_search2
		hypnotherapy = subcategories(:hypnotherapy)
		canterbury_christchurch_city = districts(:canterbury_christchurch_city)
		sgardiner = users(:sgardiner)
		norma = users(:norma)
		norma.paid_photo = true
		norma.save!
		norma.reload
		get :search, :where => canterbury_christchurch_city.name, :what => hypnotherapy.name, :country_code => "nz"
		assert_response :success
		assert_equal 3, assigns(:results).size, "Results were: #{assigns(:results).map(&:name).to_sentence}"
		assert_equal norma, assigns(:results).first, "User with paid photo should be listed first"
  end

  def test_empty_search
		get :search, :where => '', :what => ''
		assert_redirected_to root_url
    assert_equal "Please enter something in What or Where", flash[:error]
  end
  
  def test_search_district_no_subcat
		canterbury_christchurch_city = districts(:canterbury_christchurch_city)
		get :search, :where => canterbury_christchurch_city.name, :what => '', :country_code => "nz"
		assert_response :success
    assert !assigns(:results).empty?
  end

  def test_search_region_no_subcat
		canterbury = regions(:canterbury)
		get :search, :where => canterbury.name, :what => '', :country_code => "nz"
		assert_response :success
    assert !assigns(:results).empty?
  end

  def test_search_no_location_subcat
    hypnotherapy = subcategories(:hypnotherapy)
		get :search, :where => '', :what => hypnotherapy.name
		assert_redirected_to subcategory_url(hypnotherapy.category.slug, hypnotherapy.slug)
  end

  def test_search_no_location_category
		get :search, :where => '', :what => categories(:practitioners).name, :country_code => "nz"
		assert_response :success
    assert !assigns(:results).empty?
  end

	def test_search
		canterbury_christchurch_city = districts(:canterbury_christchurch_city)
		hypnotherapy = subcategories(:hypnotherapy)
		sgardiner = users(:sgardiner)
#    norma = users(:norma)
#    norma.user_profile.publish!
		get :simple_search, :where => canterbury_christchurch_city.id, :what => hypnotherapy.id, :country_code => "nz" 
		assert_response :success
    assert @response.body =~ /Profile coming soon/
#		puts "========== #{assigns(:results).inspect}"
		assert_equal 3, assigns(:results).size
		#full members should be listed first
		assert_equal sgardiner, assigns(:results).first, "full members should be listed first"
	end

	def test_search_no_subcategory
		canterbury_christchurch_city = districts(:canterbury_christchurch_city)
		practitioners = categories(:practitioners)
		get :simple_search, :where => canterbury_christchurch_city.id, :what => nil, :category_id => practitioners.id, :country_code => "nz"
		assert_response :success
		assert_equal 3, assigns(:results).size
	end

	def test_search_no_subcategory_all_area
		canterbury = regions(:canterbury)
		practitioners = categories(:practitioners)
		get :simple_search, :where => "r-#{canterbury.id}", :what => nil, :category_id => practitioners.id
		assert_response :success
    assert_match %r{Search results for Practitioners in Canterbury}, @response.body
	end

	def test_search_while_logged_in
		cyrille = users(:cyrille)
		canterbury_christchurch_city = districts(:canterbury_christchurch_city)
		practitioners = categories(:practitioners)
		get :simple_search, {:where => canterbury_christchurch_city.id, :what => nil, :category_id => practitioners.id}, {:user_id => cyrille.id }
		assert_response :success
	end

  def test_tag
    yoga = tags(:yoga)
    get :tag, {:id => yoga.name }
#    puts assigns(:articles)
    assert_response :success
    assert_equal 1, assigns(:articles).size
  end
end
