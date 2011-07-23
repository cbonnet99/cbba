class ContactsController < ApplicationController
  def new
    @contact = Contact.new(:receive_newsletter => true, :country_id => @country.id )
		get_districts_and_subcategories(@contact.country_id || @country.id)
		get_countries_with_nil
  end

  def create
    @contact = Contact.new(params[:contact])
    @contact.country = @country
    user = params[:contact].nil? ? nil : User.active.find_by_email(params[:contact]["email"])
    if user.nil?
      if @contact.save
        flash[:notice] = "Thank you for signing up, you will receive a confirmation email shortly"
        redirect_back_or_default thank_you_signup_newsletter_url
      else
        get_districts_and_subcategories(@contact.country_id || @country.id)
        flash.now[:error] = "Your registration could not be completed"
        render :action => "new"
      end
    else
      user.update_attribute(:receive_newsletter, true)
      flash[:notice] = "Thank you for signing up"
      redirect_back_or_default thank_you_signup_newsletter_url
    end
  end

  def confirm
    logout_keeping_session!
    contact = Contact.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when !params[:activation_code].blank? && contact && contact.unconfirmed?
      contact.confirm!
      contact.send_free_tool
      flash[:notice] = "Your account has been confirmed and you will receive your FREE tool shortly"
      redirect_to root_url
    when params[:activation_code].blank?
      flash[:error] = "Your confirmation code was missing.  Please follow the URL from your email."
      redirect_to root_url
    else 
      flash[:error]  = "We couldn't find a user with that confirmation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_to root_url
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
