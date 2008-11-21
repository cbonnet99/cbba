require File.dirname(__FILE__) + '/../test_helper'

class SearchControllerTest < ActionController::TestCase
  fixtures :all

	def test_change_category
		courses = categories(:courses)
		post :change_category, :id => courses.id
		assert_response :success
		assert_equal courses.id, session[:category_id]
	end

	def test_search
		canterbury_christchurch_city = districts(:canterbury_christchurch_city)
		hypnotherapy = subcategories(:hypnotherapy)
		sgardiner = users(:sgardiner)
		get :search, :where => canterbury_christchurch_city.id, :what => hypnotherapy.id
		assert_response :success
		
		assert_equal 2, assigns(:results).size
		#full members should be listed first
		assert_equal sgardiner, assigns(:results).first, "full members should be listed first"
	end

	def test_search_no_subcategory
		canterbury_christchurch_city = districts(:canterbury_christchurch_city)
		practitioners = categories(:practitioners)
		get :search, :where => canterbury_christchurch_city.id, :what => nil, :category_id => practitioners.id
		assert_response :success
		assert_equal 2, assigns(:results).size
	end

	def test_search_no_subcategory_all_area
		canterbury = regions(:canterbury)
		practitioners = categories(:practitioners)
		get :search, :where => "r-#{canterbury.id}", :what => nil, :category_id => practitioners.id
		assert_response :success
		assert_equal 3, assigns(:results).size
		assert_select "select[name=where]" do
			assert_select "option[value=r-#{canterbury.id}][selected=selected]"
		end
	end

	def test_search_while_logged_in
		cyrille = users(:cyrille)
		canterbury_christchurch_city = districts(:canterbury_christchurch_city)
		practitioners = categories(:practitioners)
		get :search, {:where => canterbury_christchurch_city.id, :what => nil, :category_id => practitioners.id}, {:user_id => cyrille.id }
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
