class Admin::UserActivitiesController < AdminApplicationController
  def index
    @activities = UserEvent.paginate(:include => :user, :page => params[:page], :order => "logged_at desc")
  end
  
  def show
    @user = User.find(params[:id])
    @activities = UserEvent.paginate_all_by_user_id(params[:id], :page => params[:page], :order => "logged_at desc")
  end
end
