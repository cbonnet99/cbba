class Admin::ExpertApplicationsController < AdminApplicationController

  before_filter :get_expert_application, :except => :index

  def update
    @expert_application.update_attributes(params[:expert_application])
    flash[:notice] = "The application was updated"
    redirect_to expert_applications_action_with_id_url(@expert_application, :action => "show")
  end

  def show
    get_subcategories
  end

  def index
    @expert_applications = ExpertApplication.pending
  end

  def reject
		@expert_application.rejected_at = Time.now.utc
		@expert_application.rejected_by_id = current_user.id
#		unless params[:reason_reject].nil?
#			@expert_application.reason_reject = params[:reason_reject]
#		end
		@expert_application.reject!
    flash[:notice]="Expert application was rejected"
		redirect_to expert_applications_action_url(:action => "index" )
  end

  def approve
    #does the modality already have an expert?
    if !@expert_application.subcategory.resident_expert.nil?
      flash[:error] = "This modality already has an expert: #{@expert_application.subcategory.resident_expert.name_with_email}. Please select a different modality"
      redirect_to expert_applications_action_with_id_url(@expert_application, :action => "show")
    else
      @expert_application.approved_at = Time.now.utc
      @expert_application.approved_by_id = current_user.id
      @expert_application.approve!
      flash[:notice]="Expert application was approved"
      redirect_to expert_applications_action_url(:action => "index" )
    end
  end

  protected
  def get_expert_application
    @expert_application = ExpertApplication.find(params[:id])
  end

end
