class QuestionsController < ApplicationController
  
  def new
    @blog_subcategories = BlogSubcategory.all
    @countries = get_countries
    @question = Question.new
  end
  
  def create
    @question = Question.new(params[:question])
    if @question.save
      flash[:notice] = "Success! Your question was sent. We will email you when there are answers."
      redirect_to question_url(@question)
    else
      flash[:error] = "Your question could not be saved"
      render :action => "edit" 
    end
  end
end
