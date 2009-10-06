class ContactsController < ApplicationController
  def new
    @contact = Contact.new(:receive_newsletter => true )
		get_districts_and_subcategories
  end

  def create
    @contact = Contact.new(params[:contact])
    if verify_human
    if @contact.save
      flash[:notice] = "Thank you for signing up"
      redirect_back_or_default root_url
    else
      get_districts_and_subcategories
      flash.now[:error] = "Your registration could not be completed"
      render :action => "new"
    end
    else
      get_districts_and_subcategories
      flash[:error] = "There was a problem with the words you entered, please try again"
      render :action => "new"
    end
  end
  
  def unsubscribe
    @contact = Contact.find_by_id_and_unsubscribe_token(params[:id], params[:token])
    if @contact
      @contact.update_attribute(:receive_newsletter, false)
      render :action => "unsubscribe_success"
    else
      logger.error("Unsubscribe failure for contact ID: #{params[:id]}")
      render :action => "unsubscribe_failure"      
    end
         
  end
  
end
