class UsersController < ApplicationController
  include ApplicationHelper
  
  before_filter :full_member_required, :only => [:articles]
  before_filter :login_required, :only => [:edit, :update, :publish, :new_photo, :create_photo, :publish, :articles, :renew_membership]
#	after_filter :store_location, :only => [:articles, :show]

  def redirect_website
    @user = User.find_by_slug(params[:slug])
    if @user.blank?
      flash[:error] = "This user does not exist."
      logger.error("Attempt to redirect to website for slug #{params[:slug]} (user doesn't exist)")
    else
      if @user.website.blank?
        flash[:error] = "This user does not have a Web site."
        logger.error("Attempt to redirect to website for user #{@user.email}(ID: #{@user.id})")
      else
        log_user_event UserEvent::REDIRECT_WEBSITE, "Redirected to #{@user.website}", {}, {:visited_user_id => @user.id }
        logger.debug("+++++++++++++++ redirecting to #{@user.website}")
        headers["Status"] = "301 Moved Permanently"
        redirect_to "#{@user.clean_website}"
      end
    end
  end

  def message
    @message = Message.new(params[:message])
    @user = User.find_by_free_listing_and_slug(false, params[:slug])
  end

  def upgrade_to_full_membership
    @payment = current_user.payments.pending.renewals.first
    @payment = current_user.payments.create!(Payment::TYPES[:full_member]) if @payment.nil?
    flash[:notice] = "Please complete the payment below to upgrade your membership"
    redirect_to edit_payment_path(@payment)
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
    redirect_to edit_payment_path(@payment)
  end

  def pay_resident
    # #unless there is already a pending payment
    @payment = current_user.payments.pending.resident.first
    @payment = current_user.payments.create!(Payment::TYPES[:resident_expert]) if @payment.nil?
    flash[:notice] = "Please complete the payment below to complete your resident expert membership"
    redirect_to edit_payment_path(@payment)
  end

  def renew_resident
    # #unless there is already a pending payment
    @payment = current_user.payments.pending.resident_renewals.first
    @payment = current_user.payments.create!(Payment::TYPES[:renew_resident_expert]) if @payment.nil?
    flash[:notice] = "Please complete the payment below to renew your resident expert membership"
    redirect_to edit_payment_path(@payment)
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
      flash[:error]="Error while uploading your photo. Our administrator has been notified. Please try again later. Our sincere apologies for the inconvenience."
    end
		redirect_to expanded_user_path(@user)
  end

	def publish
    if current_user.user_profile.draft?
      current_user.user_profile.publish!
      flash[:notice] = "Your profile was successfully published"
      redirect_to expanded_user_path(current_user)
    else
      flash[:error] = "Your profile is already published"
      redirect_to expanded_user_path(current_user)
    end
	end

	def unpublish
    if current_user.user_profile.published?
      current_user.user_profile.remove!
      flash[:notice] = "Your profile is no longer published"
      redirect_to expanded_user_path(current_user)
    else
      flash[:error] = "Your profile is not published"
      redirect_to expanded_user_path(current_user)
    end
	end

  def show
    @user = User.find_by_slug(params[:name])
    if @user.nil? || !@user.full_member?
      flash[:notice] = "Sorry, we could not find this user"
      redirect_to root_url
    else
      # #we don't want to count the visits to our own profile
      unless @user == current_user
        log_user_event UserEvent::VISIT_PROFILE, "", "", {:visited_user_id => @user.id, :category_id => params[:category_id], :subcategory_id => params[:subcategory_id], :region_id => params[:region_id], :district_id => params[:district_id], :article_id => params[:article_id]}
      end
      @selected_tab = @user.select_tab(params[:selected_tab_id])
      if !@selected_tab.nil?
        if @selected_tab.slug == Tab::ARTICLES
          if @user == current_user
            @articles = Article.all_articles(current_user)
          else
            @articles = Article.all_published_articles(@user)
          end
        end
        if @selected_tab.slug == Tab::SPECIAL_OFFERS
          if @user == current_user
            @special_offers = SpecialOffer.find_all_by_author_id(current_user.id, :order => "state, updated_at desc")
          else
            @special_offers = SpecialOffer.find_all_by_author_id_and_state(@user.id, "published", :order => "published_at desc")
          end
        end
      end

    end
  end

	def articles
    logger.debug "========= calling articles on user"
		get_districts_and_subcategories
		@articles = Article.find_all_by_author_id(current_user.id, :order => "state, updated_at desc")
	end

	def gift_vouchers
		@gift_vouchers = GiftVoucher.find_all_by_author_id(current_user.id, :order => "state, updated_at desc")
	end

	def howtos
		get_districts_and_subcategories
		@howtos = HowTo.find_all_by_author_id(current_user.id, :order => "state, updated_at desc")
	end

	def edit
    #    current_user.disassemble_phone_numbers
		get_districts_and_subcategories
    current_user.set_membership_type
    @mt = current_user.membership_type
	end

	def update_password
		if current_user.update_attributes(params[:user])
      redirect_to expanded_user_path(current_user)
      flash[:notice] = "Your password has been updated"
    else
      flash.now[:error]  = "There were some errors in your password details."
      render :action => 'edit_password'
    end
	end

	def update
    @user = current_user
    params[:user].delete("password")
    params[:user].delete("password_confirmation")
		if @user.update_attributes(params[:user])
      redirect_to expanded_user_path(@user)
      @user.region_name(:reload)
      @user.main_expertise(:reload)
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
      redirect_to new_expert_application_path(:subcategory_id => params[:subcategory_id])
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
           flash[:notice] = "You can now complete your payment"
          session[:user_id] = @user.id
          @payment = @user.payments.create!(Payment::TYPES[:full_member])
          redirect_to edit_payment_path(@payment)
        when "resident_expert":
           @user.activate!
          session[:user_id] = @user.id
          redirect_to new_expert_application_path
        else
          @user.activate!
          session[:user_id] = @user.id
          flash[:notice] = "Welcome to BeAmazing!"
          redirect_to user_membership_path
        end
      else
        get_districts_and_subcategories
        flash.now[:error]  = "There were some errors in your signup information."
        render :action => 'new'
      end
    else
      flash[:error] = "There was a problem with the words you entered, please try again"
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
      redirect_to expanded_user_path(@user)
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_to expanded_user_path(@user)
    end
  end
end
