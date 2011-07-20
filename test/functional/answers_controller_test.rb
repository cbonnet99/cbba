require File.dirname(__FILE__) + '/../test_helper'

class AnswersControllerTest < ActionController::TestCase
  
  def test_new
    question = Factory(:question)
    user = Factory(:user)

    get :new, {:question_id => question.id}, {:user_id => user.id}

    assert_response :success
  end
  
  def test_create
    question = Factory(:question)
    assert_equal 0, question.answers.size
    user = Factory(:user)
    
    post :create, {:question_id => question.id, :answer => {:question_id => question.id, :body => "Super answer HERE"}}, {:user_id => user.id}
    
    assert_redirected_to question_url(question)
    question.reload
    assert_equal 1, question.answers.size
    answer = question.answers.first
    assert_not_nil answer.user
    assert_equal "Super answer HERE", answer.body
  end
end
