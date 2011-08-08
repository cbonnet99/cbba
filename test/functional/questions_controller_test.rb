require File.dirname(__FILE__) + '/../test_helper'

class QuestionsControllerTest < ActionController::TestCase
  
  def test_new
    get :new
    assert_response :success
  end
  
  def test_create
    cat1 = Factory(:blog_category)
    nz = countries(:nz)
    question_count = Question.all.count
    
    post :create, :question => {:country_id => nz.id, :email => "new_user@test.com", 
      :blog_category_id => cat1, :body => "How do I improve my karma?", :receive_newsletter => true}
    
    question = assigns(:question)
    assert_equal "published", question.state
    assert_equal "How do I improve my karma?", question.body
    assert_redirected_to question_url(question)
    assert_equal question_count+1, Question.all.count
    new_contact = Contact.find_by_email("new_user@test.com")
    assert !new_contact.blank?
    assert new_contact.receive_newsletter?
  end

  def test_create_no_country
    cat1 = Factory(:blog_category)
    question_count = Question.all.count
    
    post :create, :question => {:country_id => nil, :email => "new_user@test.com", 
      :blog_category_id => cat1, :body => "How do I improve my karma?", :receive_newsletter => true}
    
    question = assigns(:question)
    assert_equal "published", question.state
    assert_equal "How do I improve my karma?", question.body
    assert_redirected_to question_url(question)
    assert_equal question_count+1, Question.all.count
    new_contact = Contact.find_by_email("new_user@test.com")
    assert !new_contact.blank?
    assert new_contact.receive_newsletter?
  end
  
  def test_index
    published_question = Factory(:question, :state => "published")
    draft_question = Factory(:question, :state => "draft")
    
    get :index
    
    assert_response :success
    assert_equal 1, assigns(:questions).size, "Draft question should not be shown"
  end
end
