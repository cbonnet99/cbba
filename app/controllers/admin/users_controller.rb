class Admin::UsersController < AdminApplicationController
  before_filter :get_selected_user, :only => [:edit, :update, :login, :reactivate, :deactivate, :warning_deactivate]

  def renewals
    @count_expired_users_in_last_year = User.count(:all, :conditions => ["paid_photo_until between ? and ?", 365.days.ago, Time.now])
    @count_renewed_payments_in_last_year = Payment.count(:all, :conditions => ["created_at between ? and ? ", 365.days.ago, Time.now])
    @total_last_year = @count_expired_users_in_last_year + @count_renewed_payments_in_last_year
    
    if @total_last_year == 0
      @renewal_rate_last_year = nil
    else
      @renewal_rate_last_year = ((@count_renewed_payments_in_last_year.to_f/@total_last_year.to_f)*100).to_i
    end

    @expired_users_in_past_month = User.find(:all, :conditions => ["paid_photo_until between ? and ?", 30.days.ago, Time.now])
    @renewed_payments_in_past_month = Payment.find(:all, :include => "user", :conditions => ["created_at between ? and ? ", 30.days.ago, Time.now])
    @total_last_month = @expired_users_in_past_month.try(:size) + @renewed_payments_in_past_month.try(:size)
    if @renewed_payments_in_past_month.empty?
      if @expired_users_in_past_month.empty?
        @renewal_rate_last_month = nil
      else
        @renewal_rate_last_month = 0
      end
    else
      @renewal_rate_last_month = ((@renewed_payments_in_past_month.size.to_f/@total_last_month.to_f)*100).to_i
    end

    @expiring_users_in_coming_month = User.find(:all, :conditions => ["paid_photo_until between ? and ?", 30.days.from_now, Time.now])
  end
  
  def edit
    get_subcategories
  end

  def update
    if @selected_user.check_and_update_attributes(params[:user])
      flash[:notice] = "User updated"
      redirect_to search_admin_users_url(:search_term => params[:search_term])
    else
      get_subcategories
      flash.now[:error] = "Error while updating your user"
      render :action => "edit"
    end
  end
  
  def search
    unless params[:search_term].nil?
      search_term = "%#{params[:search_term]}%"
      states = params.keys.select{|k| k.to_s.starts_with?("user_status")}.map{|k| "'#{params[k]}'"}.join(", ")
      states = "''" if states.empty?
      @users = User.paginate_by_sql(
        ["SELECT u.* from users u where state in (#{states}) and (UPPER(first_name) LIKE ? or UPPER(last_name) LIKE ? or UPPER(email) LIKE ?) ORDER BY first_name, last_name", search_term.upcase, search_term.upcase, search_term.upcase],
         :page => params[:page])
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
        redirect_to expanded_user_url(current_user)
      else
        redirect_to user_edit_url
      end
    end
  end
  
  def reactivate
    @selected_user.reactivate!
    flash[:notice] = "#{@selected_user.name}'s profile was restored"
    redirect_to search_admin_users_url(:search_term => params[:search_term] )
  end  
  
  def deactivate
    if @selected_user.nil?
      flash[:error]="User not found"
    else
      if @selected_user.warning_deactivate?
        if params[:confirm] == "true"
          log_bam_user_event UserEvent::USER_DEACTIVATED, "", "Admin #{current_user} deactivated user #{@selected_user.full_name}"
          @selected_user.deactivate!
          flash[:notice]="#{@selected_user.name}'s profile was deactivated"
          redirect_to search_admin_users_url(:search_term => params[:search_term])
        else        
          flash[:error] = "Warning"
          redirect_to warning_deactivate_admin_user_url(:search_term => params[:search_term] )
        end
      else
        log_bam_user_event UserEvent::USER_DEACTIVATED, "", "Admin #{current_user} deactivated user #{@selected_user.full_name}"
        @selected_user.deactivate!
        flash[:notice]="#{@selected_user.name}'s profile was deactivated"
        redirect_to search_admin_users_url(:search_term => params[:search_term])
      end
    end
  end
  
end
