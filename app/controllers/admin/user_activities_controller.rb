class Admin::UserActivitiesController < AdminApplicationController
  def index
    if params[:username].blank?
      @activities = UserEvent.paginate(:include => :user, :page => params[:page], :order => "logged_at desc")
    else  
      param = "%#{params[:username].upcase}%"
      @activities = UserEvent.paginate(:include => :user, :conditions => ["upper(email) like ? or upper(users.first_name) like ? or upper(users.last_name) like ?", param, param, param], :page => params[:page], :order => "logged_at desc")
    end
  end
  
  def show
    @user = User.find(params[:id])
    @activities = UserEvent.paginate_all_by_user_id(params[:id], :page => params[:page], :order => "logged_at desc")
  end
end
