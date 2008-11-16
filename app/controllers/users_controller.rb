class UsersController < ApplicationController
  before_filter :login_required, :only => [:edit, :update]

	def profile
		get_regions_and_districts
		@articles = Article.find_all_by_author_id(current_user.id, :order => "updated_at desc")
	end

	def edit
		get_regions_and_districts
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
			params[:user].delete("password")
			params[:user].delete("password_confirmation")
		if current_user.update_attributes(params[:user])
      redirect_back_or_default root_url
      flash[:notice] = "Your details have been updated"
    else
			get_regions_and_districts
      flash.now[:error]  = "There were some errors in your details."
      render :action => 'edit'
    end
	end

	def search
		@region = Region.find(params[:region_id])
		@district = District.find(params[:district_id])
		@category = Category.find(params[:category_id])
		@professionals = User.find_all_by_category_id_and_district_id_and_free_listing_and_professional_and_region_id(@category.id, @district.id, true, true, @region.id)
	end

  def new
    @user = User.new
		get_regions_and_districts
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    @user.register! if @user && @user.valid?
    success = @user && @user.valid?
    if success && @user.errors.empty?
      redirect_back_or_default root_url
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
			get_regions_and_districts
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

	def get_regions_and_districts
    get_districts
		get_subcategories
	end
end
