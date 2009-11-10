class SessionsController < ApplicationController

  include ApplicationHelper

  def new
    unless params[:return_to].blank?
      session[:return_to] = params[:return_to]
    end
  end

  def create
    logout_keeping_session!
    user = User.authenticate(params[:email], params[:password])
    if user
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      if current_user.full_member?
        if current_user.active?
          log_bam_user_event(UserEvent::LOGIN, "", "Success")
          flash.now[:notice] = "Logged in successfully"
          if current_user.admin?
            redirect_back_or_default reviewer_url(:action => "index")
          else
            redirect_back_or_default expanded_user_url(current_user)
          end
        else
          @payment = current_user.find_current_payment
          flash.now[:warning] = "You need to complete your payment"
          redirect_back_or_default edit_payment_url(@payment)
        end
      else
        log_bam_user_event(UserEvent::LOGIN, "", "Success")
        flash.now[:notice] = "Logged in successfully"
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
    flash.now[:notice] = "You have been logged out."
    redirect_to root_url(:protocol => APP_CONFIG[:site_protocol])
  end

  protected

  def note_failed_signin
    flash.now[:warning] = "Couldn't log you in as '#{params[:email]}'"
    logger.warn "Failed login for '#{params[:email]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
