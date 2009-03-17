class GiftVouchersController < ApplicationController
  def index_public
    @gift_vouchers = current_user.gift_vouchers.all
  end

	def publish
    @gift_voucher = current_user.gift_vouchers.find(params[:id])
    if current_user.gift_vouchers.published.size >= current_user.max_published_gift_vouchers
      flash[:error] = "You can only have #{help.pluralize(current_user.max_published_gift_vouchers, "special offer")} published at any time"
    else
      @gift_voucher.publish!
      flash[:notice] = "Special offer successfully published"
    end
    redirect_back_or_default @gift_voucher
		rescue ActiveRecord::RecordNotFound => e
			flash[:error] = "You can not publish this special offer"
      redirect_back_or_default @gift_voucher
	end

	def unpublish
    @gift_voucher = current_user.gift_vouchers.find(params[:id])
		@gift_voucher.remove!
		flash[:notice] = "Special offer is no longer published"
    redirect_back_or_default @gift_voucher

		rescue ActiveRecord::RecordNotFound => e
			flash[:error] = "You can not unpublish this special offer"
      redirect_back_or_default @gift_voucher
	end

  def index
    @gift_vouchers = current_user.gift_vouchers.all
  end

  def show
    @gift_voucher = current_user.gift_vouchers.find_by_slug(params[:id])
  end

  def new
    @gift_voucher = current_user.gift_vouchers.new
  end

  def create
    @gift_voucher = current_user.gift_vouchers.new(params[:gift_voucher])
    if @gift_voucher.save
      flash[:notice] = "Successfully created special offer."
      redirect_to @gift_voucher
    else
      render :action => 'new'
    end
  end

  def edit
    @gift_voucher = current_user.gift_vouchers.find_by_slug(params[:id])
  end

  def update
    @gift_voucher = current_user.gift_vouchers.find_by_slug(params[:id])
    if @gift_voucher.update_attributes(params[:gift_voucher])
      flash[:notice] = "Successfully updated special offer."
      redirect_to @gift_voucher
    else
      render :action => 'edit'
    end
  end

  def destroy
    @gift_voucher = current_user.gift_vouchers.find_by_slug(params[:id])
    @gift_voucher.destroy
    flash[:notice] = "Successfully destroyed special offer."
    redirect_to gift_vouchers_url
  end
end
