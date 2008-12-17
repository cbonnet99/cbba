class ContactsController < ApplicationController
  def new
    @contact = Contact.new(:receive_newsletter => true )
		get_districts_and_subcategories
  end

  def create
    @contact = Contact.new(params[:contact])
    if @contact.save
      flash[:notice] = "Thank you for signing up"
      redirect_back_or_default root_url
    else
      get_districts_and_subcategories
      flash.now[:error] = "Your registration could not be completed"
      render :action => "new"
    end
  end
end