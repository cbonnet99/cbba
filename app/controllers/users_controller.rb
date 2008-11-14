class UsersController < ApplicationController

	def search
		@region = Region.find(params[:region_id])
		@district = District.find(params[:district_id])
		@category = Category.find(params[:category_id])
		@professionals = User.find_all_by_category_id_and_district_id_and_free_listing_and_professional_and_region_id(@category.id, @district.id, true, true, @region.id)
	end

  def new
    @user = User.new
    @districts = District.find(:all, :include => "region", :order => "regions.name, districts.name").collect {|d| [ d.full_name, d.id ]}
		@categories = Category.find(:all, :order => "name").collect {|d| [ d.name, d.id ]}
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
			@districts = District.find(:all, :include => "region", :order => "regions.name, districts.name").collect {|d| [ d.full_name, d.id ]}
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
