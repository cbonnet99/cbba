class MessagesController < ApplicationController
  
  def create
    @user = User.find_by_free_listing_and_id(false, params[:message]["user_id"])
    my_params = params[:message].dup
    my_params[:body].gsub!(/\r/, "<br/>")
    @message = Message.new(params[:message])
    unless @user.nil?
      if logged_in? || verify_human
        if @message.save
          UserMailer.deliver_message(@message)
          log_bam_user_event UserEvent::MSG_SENT, "Subject: #{@message.subject}", {}, {:visited_user_id => @message.user.id }
          flash[:notice] = "Your message has been sent"
          redirect_to root_url
        else
          flash[:error] = "There were some errors in your message"
          render :action => "new"
        end
      else
        flash[:error] = "There was a problem with the words you entered, please try again"
        render :action => "new"
      end
    end
  end
end
