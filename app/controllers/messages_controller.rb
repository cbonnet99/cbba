class MessagesController < ApplicationController
  
  def create
    @message = Message.new(params[:message])
    @user = User.find_active_paying_user(params[:message]["user_id"])
    if logged_in? || verify_human
      if @user.nil?
        flash[:error] = "Could not send message"
        render :action => "new"
      else
        my_params = params[:message].dup
        my_params[:body].gsub!(/\r/, "<br/>")
        if @message.save
          UserMailer.deliver_message(@message)
          log_bam_user_event UserEvent::MSG_SENT, "Subject: #{@message.subject}", {}, {:visited_user_id => @message.user.id }
          flash[:notice] = "Your message has been sent"
          redirect_to signup_newsletter_url
        else
          flash[:error] = "There were some errors in your message"
          render :action => "new"
        end
      end
    else
      flash[:error] = "There was a problem with the words you entered, please try again"
      render :action => "new"
    end
  end
end
