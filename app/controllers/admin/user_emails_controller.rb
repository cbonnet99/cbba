class Admin::UserEmailsController < ApplicationController
  
  def index
    @user_emails = UserEmail.paginate(:page => params[:page], :order => "sent_at desc")
  end
end
