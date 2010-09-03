require File.dirname(__FILE__) + '/../test_helper'

class BlogSubcategoriesControllerTest < ActionController::TestCase
  def test_show_rss
    sub = Factory(:blog_subcategory)
    author = Factory(:user)
    article = Factory(:article, :author => author, :blog_subcategory1_id => sub.id, :state => "published", :published_at => Time.now)
    get :show, {:id => sub.slug, :format => "rss"}
    assert_response :success
    assert_match %r{by #{author.name}}, @response.body
    assert_match %r{Meet #{author.name}}, @response.body
  end
  
  def test_show_rss_wrong_slug
    get :show, {:id => "wrong_slug", :format => "rss"}
    assert_response :success 
  end
  
  
end
