class ExpertApplicationsController < ApplicationController
  def new
    @expert_application = ExpertApplication.new(:subcategory_id => current_user.main_expertise_id)
    get_subcategories
  end

  def create
    @expert_application = ExpertApplication.new(params[:expert_application])
    @expert_application.user_id = current_user.id
    if @expert_application.save
      flash[:notice] = "Thank you, we will contact you soon"
      redirect_to thank_you_expert_applications_path
    else
      flash[:error] = "Your application could not be processed"
      get_subcategories
      render :action => "new"
    end
  end

  def index
  end

end
