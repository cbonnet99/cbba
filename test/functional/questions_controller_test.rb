require File.dirname(__FILE__) + '/../test_helper'

class QuestionsControllerTest < ActionController::TestCase
  
  def test_new
    get :new
    assert_response :success
  end
  
  def test_create
    sub1 = Factory(:blog_subcategory)
    nz = countries(:nz)
    question_count = Question.all.count
    
    post :create, :question => {:country_id => nz.id, :email => "new_user@test.com", :blog_subcategory1_id => sub1, :body => "How do I improve my karma?"}
    
    question = assigns(:question)
    assert_redirected_to question_url(question)
    assert_equal question_count+1, Question.all.count
    new_contact = Contact.find_by_email("new_user@test.com")
    assert !new_contact.blank?
  end
end
