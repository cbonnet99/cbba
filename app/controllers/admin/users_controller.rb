class Admin::UsersController < AdminApplicationController
  before_filter :get_selected_user, :only => [:edit, :update, :login, :destroy]
  
  def edit
    get_subcategories
  end

  def update
    if @selected_user.check_and_update_attributes(params[:user])
      flash[:notice] = "User updated"
      redirect_to search_admin_users_path(:search_term => params[:search_term])
    else
      get_subcategories
      flash.now[:error] = "Error while updating your user"
      render :action => "edit"
    end
  end
  
  def search
    unless params[:search_term].nil?
      search_term = "%#{params[:search_term]}%"
      @users = User.find_by_sql(["SELECT u.* from users u where UPPER(first_name) LIKE ? or UPPER(last_name) LIKE ? or UPPER(email) LIKE ? ORDER BY first_name, last_name", search_term.upcase, search_term.upcase, search_term.upcase])
    end
  end
  
  def login
    if @selected_user.nil?
      flash[:error]="User not found"
      redirect_to :controller => "admin/users", :action => "search"  
    else
      logout_keeping_session!
      self.current_user = @selected_user
      log_bam_user_event(UserEvent::ADMIN_LOGIN, "", "Success")
      flash[:notice]="Logged in successfully"
      if @selected_user.full_member?
        redirect_to expanded_user_path(current_user)
      else
        redirect_to user_edit_path
      end
    end
  end
  
  def destroy
    if @selected_user.nil?
      flash[:error]="User not found"
    else
      log_bam_user_event UserEvent::USER_DELETED, "", "Admin #{current_user} deleted user #{@selected_user.full_name}"
      @selected_user.destroy
      flash[:notice]="User deleted"
    end
    redirect_to search_admin_users_path(:search_term => params[:search_term])
  end
  
end
