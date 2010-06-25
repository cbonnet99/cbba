require File.dirname(__FILE__) + '/../test_helper'

class SubcategoriesControllerTest < ActionController::TestCase
  include ApplicationHelper
  fixtures :all

  def test_index_js
    get :index, :format => "js"
    assert_response :success
  end
  
  def test_region
    plenty = regions(:plenty)
    get :region, {:region_slug => plenty.slug,
      :category_slug => categories(:courses).slug,
      :subcategory_slug => subcategories(:yoga).slug}
    assert_response:success
    assert_equal plenty, assigns(:region)
  end

  def test_region_error_region
    plenty = regions(:plenty)
    get :region, {:region_slug => "bla",
      :category_slug => categories(:courses).slug,
      :subcategory_slug => subcategories(:yoga).slug}
    assert_redirected_to root_url
    assert "Could not find this subcategory", flash[:error]
  end

  def test_region_error_category
    plenty = regions(:plenty)
    get :region, {:region_slug => plenty.slug,
      :category_slug => "bla",
      :subcategory_slug => subcategories(:yoga).slug}
    assert_redirected_to root_url
    assert "Could not find this subcategory", flash[:error]
  end

  def test_region_error_subcategory
    plenty = regions(:plenty)
    get :region, {:region_slug => plenty.slug,
      :category_slug => categories(:courses).slug,
      :subcategory_slug => "bla"}
    assert_redirected_to root_url
    assert "Could not find this subcategory", flash[:error]
  end
  
  def test_show
    old_size = UserEvent.all.size
    yoga = subcategories(:yoga)
    get :show, :subcategory_slug => yoga.slug, :category_slug => yoga.category.slug
    assert_response :success
    assert_equal old_size+1, UserEvent.all.size
    last_event = UserEvent.last
    assert_equal yoga.id, last_event.subcategory_id
  end

  def test_show_inactive_user
    category = Factory(:category)
    subcat = Factory(:subcategory, :category => category )
    user = Factory(:user, :subcategory1_id => subcat.id, :state => "inactive")
    get :show, :category_slug => category.slug, :subcategory_slug => subcat.slug 
    assert_response :success
    assert_select "a[href]", {:text => user.name, :count => 0}
    assert_select "h3", {:text => "#{user.name} - #{user.key_expertise_name(subcat)}", :count => 0}
  end

  
  def test_show_full_member
    yoga = subcategories(:yoga)
    norma = users(:norma)
    get :show, {:subcategory_slug => yoga.slug, :category_slug => yoga.category.slug}, {:user_id => norma.id }
    assert_response :success
  end
  
  def test_show_with_error
    yoga = subcategories(:yoga)
    get :show, :subcategory_slug => "bla", :category_slug => yoga.category.slug
    assert_redirected_to root_url
    assert "Could not find this subcategory", flash[:error]
  end
  
end
