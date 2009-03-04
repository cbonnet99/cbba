class Admin::ExpertApplicationsController < ResidentExpertAdminApplicationController

  before_filter :get_expert_application, :except => :index

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
		redirect_to expert_applications_action_path(:action => "index" )
  end

  def approve
		@expert_application.approved_at = Time.now.utc
		@expert_application.approved_by_id = current_user.id
		@expert_application.approve!
    flash[:notice]="Expert application was approved"
		redirect_to expert_applications_action_path(:action => "index" )
  end

  protected
  def get_expert_application
    @expert_application = ExpertApplication.find(params[:id])
  end

end
