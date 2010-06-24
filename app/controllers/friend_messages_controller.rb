class FriendMessagesController < ApplicationController
  def new
    @message = FriendMessage.new(:subject => params[:subject], :body => params[:body])
    if !current_user.nil?
      @message.from_user_id = current_user.id
    end
  end
  def create
    @message = FriendMessage.new(params[:friend_message])
    if !current_user.nil?
      @message.from_user_id = current_user.id
    end
    if logged_in? || verify_human
      if @message.save
        @message.send!
        log_bam_user_event UserEvent::FRIEND_MSG_SENT, "Subject: #{@message.subject}", {:from_email => @message.from_email, :to_email => @message.to_email}, {:user_id => @message.from_user_id }
        flash[:notice] = "Your message was sent"
        if params[:return_to].blank?
          redirect_to root_url
        else
          redirect_to params[:return_to]
        end
      else
        flash[:error] = "Your message could not be sent"
        render :action => "new"
      end 
    else
      flash[:error] = "There was a problem with the words you entered, please try again"
      render :action => "new"
    end
  end
end
