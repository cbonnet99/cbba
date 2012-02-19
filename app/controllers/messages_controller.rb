class MessagesController < ApplicationController
  
  def create
    if logged_in? || verify_human
      @user = User.find_active_paying_user(params[:message]["user_id"])
      if @user.nil?
        flash[:error] = "Could not send message"
        render :action => "new"
      else
        my_params = params[:message].dup
        my_params[:body].gsub!(/\r/, "<br/>")
        @message = Message.new(params[:message])
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
