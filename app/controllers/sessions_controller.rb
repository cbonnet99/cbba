class SessionsController < ApplicationController

  include ApplicationHelper

  def new
    unless params[:return_to].blank?
      session[:return_to] = params[:return_to]
    end
  end

  def create
    logout_keeping_session!
    user = User.authenticate(params[:email].downcase, params[:password])
    if user
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      if current_user.full_member?
        log_bam_user_event(UserEvent::LOGIN, "", "Success")
        current_user.update_attribute(:last_logged_at, Time.now)
        flash[:notice] = "Logged in successfully"
        if current_user.admin?
          redirect_back_or_default reviewer_url(:action => "index")
        else
          if self.current_user.published?
            redirect_back_or_default user_home_url
          else
            redirect_back_or_default expanded_user_url(current_user)
          end
        end
      else
        log_bam_user_event(UserEvent::LOGIN, "", "Success")
        flash[:notice] = "Logged in successfully"
        redirect_back_or_default user_edit_url
      end
    else
      log_bam_user_event(UserEvent::LOGIN, "", "Failure")
      note_failed_signin
      @email       = params[:email]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_to root_url(:protocol => APP_CONFIG[:logged_site_protocol])
  end

  protected

  def note_failed_signin
    flash[:warning] = "Couldn't log you in as '#{params[:email]}'"
    logger.warn "Failed login for '#{params[:email]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
