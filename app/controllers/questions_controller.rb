class QuestionsController < ApplicationController
  
  def new
    @blog_categories = get_blog_categories
    @number_users = @country.users.active.count
    get_countries_with_nil
    @question = Question.new(:receive_newsletter => true, :country_id => @country.id)
  end
  
  def create
    @question = Question.new(params[:question])
    if @question.save
      @question.publish!
      flash[:notice] = "Success! Your question was sent. We will email you when there are answers."
      redirect_to question_url(@question)
    else
      flash[:error] = "Your question could not be saved"
      render :action => "edit" 
    end
  end
  
  def show
    @question = Question.find_question(current_user, params[:id])
  end
  
  def index
    @questions = Question.find(:all, :conditions => "state = 'published'", :order => "created_at desc") 
  end
end
