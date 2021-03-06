class UsersController < ApplicationController
  include ApplicationHelper
  
  before_filter :full_member_required, :only => [:articles]
  before_filter :login_required, :except => [:confirm, :unsubscribe_unpublished_reminder, :unsubscribe, :intro, :index, :show, :redirect_website, :new, :create, :activate, :more_about_free_listing, :more_about_full_membership, :more_about_resident_expert, :message]
#	after_filter :store_location, :only => [:articles, :show]

  def select_features
    get_order
  end
  
  def reactivate
    current_user.reactivate!
    flash[:notice] = "Your profile was restored"
    redirect_to expanded_user_url(current_user)
  end

  def deactivate
    if current_user.warning_deactivate?
      if params[:confirm] == "true"
        current_user.deactivate!
        flash[:notice] = "Your profile was deleted"
        redirect_to root_url
      else
        flash[:notice] = "Warning!"
        redirect_to user_warning_deactivate_url
      end
    else      
      current_user.deactivate!
      flash[:notice] = "Your profile was deleted"
      redirect_to root_url
    end
  end

  def unsubscribe_unpublished_reminder
    @user = User.find_by_email(params[:email])
    if @user.nil?
      flash[:error] = "User not found"
      render :template => "users/error_unsubscribe" 
    else
      if @user.unsubscribe_token.blank?
        logger.error("Blank token for user #{@user.email}. Unsubscribe was allowed anyway.")
        @user.update_attribute(:notify_unpublished, false)
        flash[:notice] = "Your request has been successfully processed"
      else
        if @user.unsubscribe_token == params[:unsubscribe_token]
          @user.update_attribute(:notify_unpublished, false)
          flash[:notice] = "Your request has been successfully processed"
        else
          flash[:error] = "Invalid token"
          render :template => "users/error_unsubscribe" 
        end
      end
    end
  end
  
  def send_referrals
    emails = User.get_emails_from_string(params[:emails])
    emails.each do |email|
      UserMailer.deliver_referral(current_user, email, params[:comment])
    end
    flash[:notice] = "Thank you. #{help.pluralize(emails.size, 'email')} #{emails.size == 1 ? 'was' : 'were'} sent"
    redirect_to expanded_user_url(current_user)
  end

  def promote
    get_order
  end
  
  def unsubscribe
    @selected_user = User.find_by_slug_and_unsubscribe_token(params[:slug], params[:token])
    if @selected_user
      @selected_user.update_attribute(:receive_newsletter, false)
      render :action => "unsubscribe_success"
    else
      logger.error("Unsubscribe failure for user slug: #{params[:slug]}")
      render :action => "unsubscribe_failure"      
    end
         
  end

  def redirect_website
    @user = User.find_by_slug(params[:slug])
    if @user.blank?
      flash[:error] = "This user does not exist."
      logger.error("Attempt to redirect to website for slug #{params[:slug]} (user doesn't exist)")
      redirect_to root_url
    else
      if @user.website.blank?
        flash[:error] = "This user does not have a Web site."
        logger.error("Attempt to redirect to website for user #{@user.email}(ID: #{@user.id})")
        redirect_to root_url
      else
        log_bam_user_event UserEvent::REDIRECT_WEBSITE, "Redirected to #{@user.website}", {}, {:visited_user_id => @user.id }
        logger.debug("+++++++++++++++ redirecting to #{@user.website}")
        headers["Status"] = "301 Moved Permanently"
        redirect_to "#{@user.clean_website}"
      end
    end
  end

  def message
    begin
      @message = Message.new(params[:message])
      @user = User.find_by_free_listing_and_slug(false, params[:slug])
      if @user.nil?
        flash[:error] = "Sorry, we could not find this user"
        redirect_to root_url
      else
        @title = "Send a message"
        @title << " to #{@user.name}" if params[:hide_name] != "true"
      end
    rescue ActionController::InvalidAuthenticityToken
      #spammer probably, don't worry about it
    end
  end

  def index
    page = params[:page] || 1
    @full_members = User.paginated_full_members(page)
  end

  def new_photo
    @user = current_user
    render :layout => false
  end

  def create_photo
    @user = current_user
    if @user.update_attributes( params[:user] )
      flash[:notice]="Your photo was updated"
    else
      logger.error("Error while uploading a photo for user: #{@user.email}. Error were:")
      @user.errors.full_messages.each do |m|
        logger.error("* #{m}")
      end
      error_msg = @user.errors.full_messages.join(". ")
      
      flash[:error]="Error while uploading your photo. #{error_msg}"
    end
		redirect_to expanded_user_url(@user)
  end

	def publish
    if current_user.user_profile.draft?
      if current_user.all_tabs_valid?
        current_user.user_profile.publish!
        UserMailer.deliver_congrats_published(current_user)
        flash[:notice] = "Your profile was successfully published"
        redirect_to expanded_user_url(current_user)
      else
        flash[:error] = current_user.unedited_tabs_error_msg
        redirect_to expanded_user_url(current_user)
      end
    else
      flash[:error] = "Your profile is already published"
      redirect_to expanded_user_url(current_user)
    end
	end

	def unpublish
    if current_user.user_profile.published?
      current_user.user_profile.remove!
      flash[:notice] = "Your profile is no longer published"
      redirect_to expanded_user_url(current_user)
    else
      flash[:error] = "Your profile is not published"
      redirect_to expanded_user_url(current_user)
    end
	end

  def show
    @user = User.find_by_slug(params[:name])
    @context = "profile"
    if @user.nil? || !@user.full_member?
      flash[:notice] = "Sorry, we could not find this user"
      redirect_to root_url
    else
      @articles = @user.recent_articles
      # #we don't want to count the visits to our own profile
      unless @user == current_user
        log_bam_user_event UserEvent::VISIT_PROFILE, "", "", {:visited_user_id => @user.id, :category_id => params[:category_id], :subcategory_id => params[:subcategory_id], :region_id => params[:region_id], :district_id => params[:district_id], :article_id => params[:article_id]}
      end
      @selected_tab = @user.select_tab(params[:selected_tab_id])
      unless @selected_tab.nil?
        unless @selected_tab.virtual?
          @selected_tab.set_contents
        end
        if @selected_tab.slug == Tab::ARTICLES
          if @user == current_user
            @all_articles = Article.all_articles(current_user)
          else
            @all_articles = Article.all_published_articles(@user)
          end
        end
        if @selected_tab.slug == Tab::OFFERS
          if @user == current_user
            @all_offers = SpecialOffer.all_offers(current_user)
          else
            @all_offers = SpecialOffer.all_published_offers(@user)
          end
        end
      end

    end
  end

	def gift_vouchers
		@gift_vouchers = current_user.gift_vouchers
	end

	def special_offers
		@special_offers = current_user.special_offers
	end

	def edit
		get_districts_and_subcategories(current_user.country_id || @country.id)
	end

	def update_password
	  if User.authenticate(current_user.email, params[:user]["old_password"])
  		if current_user.update_attributes(params[:user])
        redirect_to expanded_user_url(current_user)
        flash[:notice] = "Your password has been updated"
      else
        flash.now[:error]  = "There were some errors in your password details."
        render :action => 'edit_password'
      end
    else
      flash.now[:error]  = "Sorry, your password could not be changed"
      render :action => 'edit_password'
    end
	end

	def update
    @user = current_user
		if @user.update_attributes(params[:user])
      @user.region_name(:reload)
      @user.main_expertise_name(:reload)
      flash[:notice] = "Your details have been updated"
      redirect_to expanded_user_url(@user)
    else
			get_districts_and_subcategories(current_user.country_id || @country.id)
      flash.now[:error]  = "There were some errors in your details."
      render :action => 'edit'
    end
	end

  def new
    # subcategory1_id = params[:subcategory_id].blank? ? nil : params[:subcategory_id].to_i
    get_package
    @user = User.new(:country_id => @country.id, :free_listing => @package == "free",
        :membership_type => User::PACKAGES_TO_MEMBERSHIP_TYPES[@package])
		get_districts_and_subcategories(@user.country_id || @country.id)
  end

  def edit_optional
    @user = current_user
		get_districts_and_subcategories(current_user.country_id || @country.id)
  end

  def update_optional
    @user = current_user
		if @user.update_attributes(params[:user])
		  @user.create_additional_tab(@user.subcategory2_id)
		  @user.create_additional_tab(@user.subcategory3_id)
      @user.main_expertise_name(:reload)
      flash[:notice] = "Your optional information has been saved"
      get_order(force_premium=true)
      @order.free_order!
      redirect_to expanded_user_url(@user)
    else
      flash[:error] = "There were some errors in your optional information."
      render :action => 'edit_optional'
    end
  end
 
  def create
    @user = User.new(params[:user])
      logout_keeping_session!
      if @user.save
          session[:user_id] = @user.id
          if @user.free_listing?
            @package = "free"
          else
            @package = "premium"
          end
          redirect_to :controller => "users", :action => "edit_optional", :package => @package
      else
        get_districts_and_subcategories(@user.country_id || @country.id)
        flash.now[:error]  = "There were some errors in your essential information."
        render :action => 'new'
      end
  end

  def confirm
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when !params[:activation_code].blank? && user && user.unconfirmed?
      user.confirm!
      session[:user_id] = user.id
      flash[:notice] = "Your profile has been confirmed"
      redirect_to user_home_url
    when params[:activation_code].blank?
      flash[:error] = "Your confirmation code was missing.  Please follow the URL from your email."
      redirect_to root_url
    else 
      flash[:error]  = "We couldn't find a user with that confirmation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_to login_url
    end
  end
  
protected
  def get_order(force_premium=false)
    @order = current_user.orders.pending.first
    if @order.nil?
      if force_premium
        @order = Order.create(:user_id => current_user.id, :package => "premium")
      else
        @order = Order.create(:user_id => current_user.id)
      end
    else
      @order.update_attribute(:package, "premium")
    end
  end
  
  def get_package
    @package = params[:package]
    if @package.nil?
      @package = "premium"
    end
  end
end
