class UsersController < ApplicationController
  before_filter :full_member_required, :only => [:articles]
  before_filter :login_required, :only => [:edit, :update, :publish, :new_photo, :create_photo, :publish, :articles, :renew_membership]
	after_filter :store_location, :only => [:articles, :show]

  def renew_membership
    #unless there is already a pending payment
    @payment = current_user.payments.pending.renewals.first
    @payment = current_user.payments.create!(Payment::TYPES[:renew_full_member]) if @payment.nil?
    flash[:notice] = "Please complete the payment below to renew your membership"
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
		redirect_back_or_default root_url
  end

	def publish
    current_user.user_profile.publish!
    flash[:notice] = "Your profile was successfully published"
		redirect_back_or_default root_url
	end
  
  def show
    @user = User.find_by_slug(params[:name])
    if @user.nil? || !@user.full_member?
      render :text => ""
    else
      #we don't want to count the visits to our own profile
      unless @user == current_user
        log_user_event "Visit full member profile", "", "", {:visited_user_id => @user.id, :category_id => params[:category_id], :subcategory_id => params[:subcategory_id], :region_id => params[:region_id], :district_id => params[:district_id], :article_id => params[:article_id]}
      end
      @selected_tab = @user.select_tab(params[:selected_tab_id])
      if !@selected_tab.nil? && @selected_tab.slug == Tab::ARTICLES
        if @user == current_user
          	@straight_articles = Article.find_all_by_author_id(current_user.id, :order => "state, updated_at desc")
          	@how_to_articles = HowTo.find_all_by_author_id(current_user.id, :order => "state, updated_at desc")
            @articles = @straight_articles + @how_to_articles
            @articles = @articles.sort_by(&:updated_at)
            @articles.reverse!
        else
            @straight_articles = Article.find_all_by_author_id_and_state(@user.id, "published", :order => "published_at desc")
            @how_to_articles = HowTo.find_all_by_author_id_and_state(@user.id, "published", :order => "published_at desc")
            @articles = @straight_articles + @how_to_articles
            @articles = @articles.sort_by(&:published_at)
            @articles.reverse!
        end
      else
        @articles = []
      end

    end
  end

	def articles
		get_districts_and_subcategories
		@articles = Article.find_all_by_author_id(current_user.id, :order => "state, updated_at desc")
	end

	def howtos
		get_districts_and_subcategories
		@howtos = HowTo.find_all_by_author_id(current_user.id, :order => "state, updated_at desc")
	end

	def edit
#    current_user.disassemble_phone_numbers
		get_districts_and_subcategories
    current_user.set_membership_type
	end

	def update_password
		if current_user.update_attributes(params[:user])
      redirect_back_or_default root_url
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
      redirect_back_or_default root_url
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
    mt = params[:mt] || "free_listing"
    professional_str = params[:professional] || "false"
    professional = professional_str == "true"
    @user = User.new(:membership_type => mt, :professional => professional )
		get_districts_and_subcategories
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    @user.register! if @user && @user.valid?
    success = @user && @user.valid?
    if success && @user.errors.empty?
      if @user.membership_type == "full_member"
        flash[:notice] = "You can now complete your payment"
        session[:user_id] = @user.id
        @payment = @user.payments.create!(Payment::TYPES[:full_member])
        redirect_to edit_payment_path(@payment)
      else
        flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
        redirect_back_or_default root_url
      end
    else
			get_districts_and_subcategories
      flash.now[:error]  = "There were some errors in your signup information."
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
      redirect_back_or_default root_url
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default root_url
    end
  end
end
