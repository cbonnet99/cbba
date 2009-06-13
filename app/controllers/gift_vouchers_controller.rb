class GiftVouchersController < ApplicationController
  def index
    @gift_vouchers = GiftVoucher.published
    log_user_event UserEvent::SELECT_COUNTER, "", "Gift vouchers"
  end

	def publish
    @gift_voucher = current_user.gift_vouchers.find(params[:id])
    if @gift_voucher.publish!
      flash[:notice] = "Gift voucher successfully published"
    else
      flash[:error] = "You can only have #{help.pluralize(current_user.max_published_gift_vouchers, "gift voucher")} published at any time"
    end
    redirect_to gift_vouchers_show_path(@gift_voucher.author.slug, @gift_voucher.slug)
		rescue ActiveRecord::RecordNotFound => e
			flash[:error] = "You can not publish this gift voucher"
      redirect_to gift_vouchers_show_path(@gift_voucher.author.slug, @gift_voucher.slug)
	end

	def unpublish
    @gift_voucher = current_user.gift_vouchers.find(params[:id])
		@gift_voucher.remove!
		flash[:notice] = "Gift voucher is no longer published"
    redirect_to gift_vouchers_show_path(@gift_voucher.author.slug, @gift_voucher.slug)

		rescue ActiveRecord::RecordNotFound => e
			flash[:error] = "You can not unpublish this gift voucher"
      redirect_to gift_vouchers_show_path(@gift_voucher.author.slug, @gift_voucher.slug)
	end

  def show
    get_selected_user
    if @selected_user.nil?
      flash.now[:error]="Sorry, this gift voucher could not be found"
      if params[:index_public] == "true"
        redirect_to gift_vouchers_path
      else
        redirect_to user_gift_vouchers_path
      end
    else
      @gift_voucher = @selected_user.find_gift_voucher_for_user(params[:id], current_user)
      if @gift_voucher.nil?
        flash.now[:error]="Sorry, this gift voucher could not be found"
        if params[:index_public] == "true"
          redirect_to gift_vouchers_index_public_path
        else
          redirect_to user_gift_vouchers_path
        end        
      end      
    end
  end

  def new
    @gift_voucher = current_user.gift_vouchers.new
  end

  def create
    if params["cancel"]
      flash[:notice]="Gift voucher cancelled"
      redirect_to user_gift_vouchers_path
    else  
      @gift_voucher = current_user.gift_vouchers.new(params[:gift_voucher])
      if @gift_voucher.save
        if params["save_as_draft"]
          flash[:notice] = 'Your draft gift voucher was successfully saved.'
        else
          if @gift_voucher.publish!
            flash[:notice] = 'Your gift voucher was successfully saved and published.'
          else
            flash[:error] = "Your gift voucher was saved as draft (you can only have #{help.pluralize(current_user.max_published_gift_vouchers, "gift voucher")} published at any time)"
          end
        end
        redirect_to gift_vouchers_show_path(@gift_voucher.author.slug, @gift_voucher.slug)
      else
        render :action => 'new'
      end
    end
  end

  def edit
    @gift_voucher = current_user.gift_vouchers.find_by_slug(params[:id])
  end

  def update
    if params["cancel"]
      flash[:notice]="Gift voucher cancelled"
      redirect_to user_gift_vouchers_path
    else
      @gift_voucher = current_user.gift_vouchers.find_by_slug(params[:id])
      if @gift_voucher.update_attributes(params[:gift_voucher])
        flash[:notice] = "Successfully updated gift voucher."
        redirect_to gift_vouchers_show_path(@gift_voucher.author.slug, @gift_voucher.slug)
      else
        render :action => 'edit'
      end
    end
  end

  def destroy
    @gift_voucher = current_user.gift_vouchers.find_by_slug(params[:id])
    @gift_voucher.destroy
    flash[:notice] = "Successfully destroyed gift voucher."
    redirect_to gift_vouchers_url
  end
end
