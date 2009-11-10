class GiftVouchersController < ApplicationController
  
  before_filter :login_required, :except => [:index, :index_for_subcategory, :show]
  before_filter :get_context, :except => :index 
	after_filter :store_location, :only => [:index, :show]
	
  def index_for_subcategory
    @subcategory = Subcategory.find_by_slug(params[:subcategory_slug])
    @subcategory = Subcategory.first if @subcategory.nil?
    @gift_vouchers = GiftVoucher.find_all_by_state_and_subcategory_id('published', @subcategory.id)
  end
  
  def index
    @context = "homepage"
    @gift_vouchers = GiftVoucher.published
    log_user_event UserEvent::SELECT_COUNTER, "", "Gift vouchers"
  end

	def publish
    @gift_voucher = current_user.find_gift_voucher(params[:id])
    if @gift_voucher.publish!
      flash[:notice] = "\"#{@gift_voucher.title}\" successfully published"
    else
      flash[:error] = "You can only have #{help.pluralize(current_user.max_published_gift_vouchers, "gift voucher")} published at any time"
    end
    redirect_with_context(gift_vouchers_url)
		rescue ActiveRecord::RecordNotFound => e
			flash[:error] = "You can not publish this gift voucher"
      redirect_with_context(gift_vouchers_url)
	end

	def unpublish
    @gift_voucher = current_user.find_gift_voucher(params[:id])
		@gift_voucher.remove!
		flash[:notice] = "\"#{@gift_voucher.title}\" is no longer published"
    redirect_with_context(gift_vouchers_url)

		rescue ActiveRecord::RecordNotFound => e
			flash[:error] = "You can not unpublish this gift voucher"
      redirect_with_context(gift_vouchers_url)
	end

  def show
    get_selected_user
    if @selected_user.nil?
      flash.now[:error]="Sorry, this gift voucher could not be found"
      redirect_with_context(gift_vouchers_url)
    else
      @gift_voucher = @selected_user.find_gift_voucher_for_user(params[:id], current_user)
      if @gift_voucher.nil?
        flash.now[:error]="Sorry, this gift voucher could not be found"
        redirect_with_context(gift_vouchers_url)
      end      
    end
  end

  def new
    @gift_voucher = current_user.gift_vouchers.new
    @gift_voucher.subcategory_id = current_user.subcategories.first.id unless current_user.subcategories.blank?
		get_subcategories
  end

  def create
    if params["cancel"]
      flash[:notice]="Gift voucher cancelled"
      redirect_to user_gift_vouchers_url
    else  
      @gift_voucher = current_user.gift_vouchers.new(params[:gift_voucher])
      if @gift_voucher.save
        if params["save_as_draft"]
          flash[:notice] = "\"#{@gift_voucher.title}\" was successfully saved as a draft."
        else
          if @gift_voucher.publish!
            flash[:notice] = "\"#{@gift_voucher.title}\" was successfully saved and published."
          else
            flash[:error] = "\"#{@gift_voucher.title}\" was saved as a draft (you can only have #{help.pluralize(current_user.max_published_gift_vouchers, "gift voucher")} published at any time)"
          end
        end
        redirect_to gift_vouchers_show_url(@gift_voucher.author.slug, @gift_voucher.slug, :context => @context, :selected_tab_id => @selected_tab_id)
      else
        get_subcategories
        render :action => 'new'
      end
    end
  end

  def edit
    @gift_voucher = current_user.gift_vouchers.find_by_slug(params[:id])
		get_subcategories
  end

  def update
    if params["cancel"]
      flash[:notice]="Gift voucher cancelled"
      redirect_to user_gift_vouchers_url
    else
      @gift_voucher = current_user.gift_vouchers.find_by_slug(params[:id])
      if @gift_voucher.update_attributes(params[:gift_voucher])
        flash[:notice] = "\"#{@gift_voucher.title}\" successfully updated."
        redirect_to gift_vouchers_show_url(@gift_voucher.author.slug, @gift_voucher.slug, :context => @context, :selected_tab_id => @selected_tab_id)
      else
        render :action => 'edit'
      end
    end
  end

  def destroy
    @gift_voucher = current_user.gift_vouchers.find_by_slug(params[:id])
    @title = @gift_voucher.title
    if current_user.author?(@gift_voucher)
      @gift_voucher.destroy
      flash[:notice] = "\"#{@title}\" was deleted"
    else
      flash[:error] = "You cannot delete this gift voucher"
    end
    redirect_with_context(gift_vouchers_url)
  end
end
