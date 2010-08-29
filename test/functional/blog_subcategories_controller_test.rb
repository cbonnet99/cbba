require File.dirname(__FILE__) + '/../test_helper'

class BlogSubcategoriesControllerTest < ActionController::TestCase
  def test_show_rss
    sub = Factory(:blog_subcategory)
    get :show, {:id => sub.slug, :format => "rss"}
    assert_response :success 
  end
end
