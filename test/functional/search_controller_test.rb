require File.dirname(__FILE__) + '/../test_helper'

class SearchControllerTest < ActionController::TestCase
  fixtures :all

  def test_index
    money = how_tos(:money)
    jogging = articles(:jogging)
    cyrille = users(:cyrille)
    get :index
    assert_response :success
    #2 articles + 1 howto article
    assert_select "ul#homepage-articles > li", 3
    #Create 2 more published articles
    Article.create(:title => "Test1", :lead => "Test1", :state => "published",
      :published_at => 3.days.ago, :author => cyrille )
    Article.create(:title => "Test2", :lead => "Test2", :state => "published",
      :published_at => 3.days.ago, :author => cyrille )
    get :index
    assert_response :success
    assert_select "ul#homepage-articles > li", $number_articles_on_homepage
    assert_select "a", :text => "View more articles..."
    assert_equal 2, assigns(:newest_full_members).size
    assert assigns(:newest_articles).include?(money)
    assert_equal $number_articles_on_homepage, assigns(:newest_articles).size
    assert assigns(:newest_articles).index(money) < assigns(:newest_articles).index(jogging)
  end

	def test_change_category
		courses = categories(:courses)
    old_size = UserEvent.all.size
		post :change_category, :id => courses.id
		assert_response :success
		assert_equal courses.id, session[:category_id]
    assert_equal old_size+1, UserEvent.all.size
	end

	def test_change_category_with_user
		courses = categories(:courses)
    cyrille = users(:cyrille)
    old_size = UserEvent.all.size
		post :change_category, {:id => courses.id}, {:user_id => cyrille.id }
		assert_response :success
		assert_equal courses.id, session[:category_id]
    assert_equal old_size+1, UserEvent.all.size
    assert_not_nil UserEvent.find(:all, :order => "logged_at desc").first.user_id
    assert_not_nil UserEvent.find(:all, :order => "logged_at desc").first.category_id
	end

  def test_fuzzy_search
		hypnotherapy = subcategories(:hypnotherapy)
		canterbury_christchurch_city = districts(:canterbury_christchurch_city)
		sgardiner = users(:sgardiner)
		get :fuzzy_search, :fuzzy_where => canterbury_christchurch_city.name, :fuzzy_what => hypnotherapy.name
		assert_response :success
    assert @response.body =~ /Full profile coming soon/
#		puts "========== #{assigns(:results).inspect}"
		assert_equal 3, assigns(:results).size
		#full members should be listed first
		assert_equal sgardiner, assigns(:results).first, "full members should be listed first"
  end

  def test_fuzzy_empty_search
		get :fuzzy_search, :fuzzy_where => '', :fuzzy_what => ''
		assert_redirected_to root_url
    assert_equal "Please enter something in What or Where", flash[:error]
  end
  
  def test_fuzzy_search_district_no_subcat
		canterbury_christchurch_city = districts(:canterbury_christchurch_city)
		get :fuzzy_search, :fuzzy_where => canterbury_christchurch_city.name, :fuzzy_what => ''
		assert_response :success
    assert !assigns(:results).empty?
  end

  def test_fuzzy_search_region_no_subcat
		canterbury = regions(:canterbury)
		get :fuzzy_search, :fuzzy_where => canterbury.name, :fuzzy_what => ''
		assert_response :success
    assert !assigns(:results).empty?
  end

  def test_fuzzy_search_no_location_subcat
    hypnotherapy = subcategories(:hypnotherapy)
		get :fuzzy_search, :fuzzy_where => '', :fuzzy_what => hypnotherapy.name
		assert_response :success
    assert !assigns(:results).empty?
    assert_match %r{Search results for #{hypnotherapy.name}}, @response.body
  end

  def test_fuzzy_search_no_location_category
		get :fuzzy_search, :fuzzy_where => '', :fuzzy_what => categories(:practitioners).name
		assert_response :success
    assert !assigns(:results).empty?
  end

	def test_search
		canterbury_christchurch_city = districts(:canterbury_christchurch_city)
		hypnotherapy = subcategories(:hypnotherapy)
		sgardiner = users(:sgardiner)
#    norma = users(:norma)
#    norma.user_profile.publish!
		get :simple_search, :where => canterbury_christchurch_city.id, :what => hypnotherapy.id
		assert_response :success
    assert @response.body =~ /Full profile coming soon/
#		puts "========== #{assigns(:results).inspect}"
		assert_equal 3, assigns(:results).size
		#full members should be listed first
		assert_equal sgardiner, assigns(:results).first, "full members should be listed first"
	end

	def test_search_no_subcategory
		canterbury_christchurch_city = districts(:canterbury_christchurch_city)
		practitioners = categories(:practitioners)
		get :simple_search, :where => canterbury_christchurch_city.id, :what => nil, :category_id => practitioners.id
		assert_response :success
		assert_equal 3, assigns(:results).size
	end

	def test_search_no_subcategory_all_area
		canterbury = regions(:canterbury)
		practitioners = categories(:practitioners)
		get :simple_search, :where => "r-#{canterbury.id}", :what => nil, :category_id => practitioners.id
		assert_response :success
    assert_match %r{Search results for Practitioners in Canterbury}, @response.body
#    puts "========= assigns(:results):"
#    assigns(:results).each do |r|
#      puts r.name
#    end
		assert_equal 4, assigns(:results).size
		assert_select "select[name=where]" do
			assert_select "option[value=r-#{canterbury.id}][selected=selected]"
		end
	end

	def test_search_while_logged_in
		cyrille = users(:cyrille)
		canterbury_christchurch_city = districts(:canterbury_christchurch_city)
		practitioners = categories(:practitioners)
		get :simple_search, {:where => canterbury_christchurch_city.id, :what => nil, :category_id => practitioners.id}, {:user_id => cyrille.id }
		assert_response :success
		#User cyrille is logged but has selected a different district than his default
		assert_select "select#where > option[value=#{canterbury_christchurch_city.id}][selected=selected]"
	end

  def test_tag
    yoga = tags(:yoga)
    get :tag, {:id => yoga.name }
#    puts assigns(:articles)
    assert_response :success
    assert_equal 1, assigns(:articles).size
  end
end
