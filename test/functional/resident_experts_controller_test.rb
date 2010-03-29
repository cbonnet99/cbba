require File.dirname(__FILE__) + '/../test_helper'

class ResidentExpertsControllerTest < ActionController::TestCase
  fixtures :all
  
  def test_index
    sub1 = Factory(:subcategory)
    sub2 = Factory(:subcategory)
    user = Factory(:user, :subcategory1_id  => sub1.id)
    user2 = Factory(:user, :subcategory1_id  => sub1.id)
    
    article1 = Factory(:article, :author => user, :published_at => 2.days.ago)
    Factory(:articles_subcategory, :article_id => article1.id, :subcategory_id => sub1.id)  
    article2 = Factory(:article, :author => user, :published_at => 32.days.ago)
    article4 = Factory(:article, :author => user, :published_at => 2.days.ago)
    Factory(:articles_subcategory, :article_id => article4.id, :subcategory_id => sub2.id)
    
    TaskUtils.recompute_points
    
    get :index
    assert_response :success
  end
end
