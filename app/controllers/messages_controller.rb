class MessagesController < ApplicationController
  def create
    @user = User.find_by_free_listing_and_id(false, params[:message]["user_id"])
    @message = Message.new(params[:message])
    unless @user.nil?
      if verify_human
        if @message.save
          UserMailer.deliver_message(@message)
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
