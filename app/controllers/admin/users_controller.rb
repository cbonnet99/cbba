class Admin::UsersController < AdminApplicationController
  def search
    unless params[:search_term].nil?
      search_term = "%#{params[:search_term]}%"
      @users = User.find_by_sql(["SELECT u.* from users u where UPPER(first_name) LIKE ? or UPPER(last_name) LIKE ? or UPPER(email) LIKE ? ORDER BY first_name, last_name", search_term.upcase, search_term.upcase, search_term.upcase])
    end
  end
  
  def login
    @user = User.find(params[:id])
    if @user.nil?
      flash[:error]="User not found"
      redirect_to :controller => "admin/users", :action => "search"  
    else
      logout_keeping_session!
      self.current_user = @user
      log_user_event(UserEvent::ADMIN_LOGIN, "", "Success")
      flash[:notice]="Logged in successfully"
      if @user.full_member?
        redirect_to expanded_user_path(current_user)
      else
        redirect_to user_edit_path
      end
    end
  end
  
end
