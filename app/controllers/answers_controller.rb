class AnswersController < ApplicationController
  
  before_filter :login_required, :except => [:index, :show]
  
  def new
    @answer = Answer.new(:question_id => params[:question_id] )
  end
  
  def create
    @answer = Answer.new(params[:answer].merge(:user => current_user))
    if @answer.save
      flash[:success] = "Your answer has been saved"
      redirect_to question_url(@answer.question.id)
    else
      flash[:error] = "Your answer could not be saved"
      render :action => "new" 
    end
  end
end
