class Admin::UserActivitiesController < AdminApplicationController
  def index
    @activities = UserEvent.paginate_by_event_type(UserEvent::LOGIN, :page => params[:page], :order => "logged_at desc")
  end
end
