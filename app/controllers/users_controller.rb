class UsersController < ApplicationController
  include ApplicationHelper
  
  before_filter :full_member_required, :only => [:articles]
  before_filter :login_required, :except => [:unsubscribe_unpublished_reminder, :unsubscribe, :intro, :index, :show, :redirect_website, :new, :create, :activate, :more_about_free_listing, :more_about_full_membership, :more_about_resident_expert, :message]
#	after_filter :store_location, :only => [:articles, :show]

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
        if @user.unsubscribe_token == params[:token]
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
    @order = current_user.orders.pending.first
    @order = Order.new if @order.nil?
    if !@order.photo? && !current_user.paid_photo_until.nil? &&  Time.parse(current_user.paid_photo_until.to_s) > 3.months.ago
      #the user paid for a photo that expired recently: let's guess it is a renewal
      @order.photo = true
    end
    if !@order.highlighted? && !current_user.paid_highlighted_until.nil? && Time.parse(current_user.paid_highlighted_until.to_s) > 3.months.ago
      @order.highlighted = true
    end
    if @order.special_offers == 0 && !current_user.paid_special_offers_next_date_check.nil? &&  Time.parse(current_user.paid_special_offers_next_date_check.to_s) > 3.months.ago
      @order.special_offers = 1
    end
    if @order.gift_vouchers == 0 && !current_user.paid_gift_vouchers_next_date_check.nil? &&  Time.parse(current_user.paid_gift_vouchers_next_date_check.to_s) > 3.months.ago
      @order.gift_vouchers = 1
    end
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

  def upgrade_to_full_membership
    @payment = current_user.payments.pending.renewals.first
    @payment = current_user.payments.create!(Payment::TYPES[:full_member]) if @payment.nil?
    flash[:notice] = "Please complete the payment below to upgrade your membership"
    redirect_to edit_payment_url(@payment)
  end

  def membership
    @payment = current_user.payments.pending.find(:first, :order => "created_at desc" )
    @new_member = current_user.member_since.nil?
    @new_resident = current_user.resident_since.nil?
    @awaiting_payment_expert_apps = current_user.expert_applications.approved_without_payment
    @pending_expert_apps = current_user.expert_applications.pending
  end

  def renew_membership
    # #unless there is already a pending payment
    @payment = current_user.payments.pending.renewals.first
    @payment = current_user.payments.create!(Payment::TYPES[:renew_full_member]) if @payment.nil?
    flash[:notice] = "Please complete the payment below to renew your membership"
    redirect_to edit_payment_url(@payment)
  end

  def pay_resident
    # #unless there is already a pending payment
    @payment = current_user.payments.pending.resident.first
    @payment = current_user.payments.create!(Payment::TYPES[:resident_expert]) if @payment.nil?
    flash[:notice] = "Please complete the payment below to complete your resident expert membership"
    redirect_to edit_payment_url(@payment)
  end

  def renew_resident
    # #unless there is already a pending payment
    @payment = current_user.payments.pending.resident_renewals.first
    @payment = current_user.payments.create!(Payment::TYPES[:renew_resident_expert]) if @payment.nil?
    flash[:notice] = "Please complete the payment below to renew your resident expert membership"
    redirect_to edit_payment_url(@payment)
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
      if current_user.unedited_tabs.blank?
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
      # #we don't want to count the visits to our own profile
      unless @user == current_user
        log_bam_user_event UserEvent::VISIT_PROFILE, "", "", {:visited_user_id => @user.id, :category_id => params[:category_id], :subcategory_id => params[:subcategory_id], :region_id => params[:region_id], :district_id => params[:district_id], :article_id => params[:article_id]}
      end
      @selected_tab = @user.select_tab(params[:selected_tab_id])
      unless @selected_tab.nil?
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
    #    current_user.disassemble_phone_numbers
		get_districts_and_subcategories
    current_user.set_membership_type
    @mt = current_user.membership_type
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
    params[:user].delete("password")
    params[:user].delete("password_confirmation")
		if @user.update_attributes(params[:user])
      redirect_to expanded_user_url(@user)
      @user.region_name(:reload)
      @user.main_expertise_name(:reload)
      flash[:notice] = "Your details have been updated"
    else
			get_districts_and_subcategories
      flash.now[:error]  = "There were some errors in your details."
      render :action => 'edit'
    end
	end

  def new
    @mt = params[:mt] || "free_listing"
    if logged_in? && @mt == "resident_expert"
      redirect_to new_expert_application_url(:subcategory_id => params[:subcategory_id])
    end
    professional_str = params[:professional] || "false"
    professional = professional_str == "true"
    subcategory1_id = params[:subcategory_id].blank? ? nil : params[:subcategory_id].to_i
    @user = User.new(:membership_type => @mt, :professional => professional, :subcategory1_id => subcategory1_id  )
		get_districts_and_subcategories
  end
 
  def create
    @user = User.new(params[:user])
    if verify_human
      logout_keeping_session!
      @user.register! if @user && @user.valid?
      success = @user && @user.valid?
      if success && @user.errors.empty?
        case @user.membership_type
        when "full_member":
          @user.activate!
          session[:user_id] = @user.id
          redirect_to :controller => "users", :action => "welcome"  
        when "resident_expert":
           @user.activate!
          session[:user_id] = @user.id
          redirect_to new_expert_application_url
        else
          @user.activate!
          session[:user_id] = @user.id
          flash[:notice] = "Welcome to BeAmazing!"
          redirect_to user_membership_url
        end
      else
        get_districts_and_subcategories
        flash.now[:error]  = "There were some errors in your signup information."
        @mt = @user.membership_type
        render :action => 'new', :subcategory1_id => params[:user]["subcatgory1_id"] 
      end
    else
      flash[:error] = "There was a problem with the words you entered with the security check. Did you see an image with words to type? If not, "
      get_districts_and_subcategories
      render :action => 'new'
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when !params[:activation_code].blank? && user && !user.active?
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to  login_url
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_to expanded_user_url(@user)
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_to expanded_user_url(@user)
    end
  end
end
