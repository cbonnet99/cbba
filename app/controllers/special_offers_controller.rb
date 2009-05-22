require File.dirname(__FILE__) + '/../../lib/helpers'
require 'pdf/writer'
class SpecialOffersController < ApplicationController

  before_filter :login_required, :except => [:index_public]
	after_filter :store_location, :only => [:index, :show]

  def index_public
    @special_offers = SpecialOffer.published
    log_user_event UserEvent::SELECT_COUNTER, "", "Special offers"
  end

	def publish
    @special_offer = current_user.special_offers.find(params[:id])
    if current_user.special_offers.published.size >= current_user.max_published_special_offers
      flash[:error] = "You can only have #{help.pluralize(current_user.max_published_special_offers, "special offer")} published at any time"
    else
      @special_offer.publish!
      flash[:notice] = "Special offer successfully published"
    end
    redirect_back_or_default @special_offer
		rescue ActiveRecord::RecordNotFound => e
			flash[:error] = "You can not publish this special offer"
      redirect_back_or_default @special_offer
	end

	def unpublish
    @special_offer = current_user.special_offers.find(params[:id])
		@special_offer.remove!
		flash[:notice] = "Special offer is no longer published"
    redirect_back_or_default @special_offer

		rescue ActiveRecord::RecordNotFound => e
			flash[:error] = "You can not unpublish this special offer"
      redirect_back_or_default @special_offer
	end

  def index
    @special_offers = current_user.special_offers.all
  end
  
  def show
    @special_offer = current_user.special_offers.find_by_slug(params[:id])
  end
  
  def new
    @special_offer = current_user.special_offers.new
    @special_offer.how_to_book = current_user.default_how_to_book
    @special_offer.terms = SpecialOffer::DEFAULT_TERMS
  end
  
  def create
    @special_offer = current_user.special_offers.new(params[:special_offer])
    if @special_offer.save
      flash[:notice] = "Successfully created special offer."
      redirect_to @special_offer
    else
      render :action => 'new'
    end
  end
  
  def edit
    @special_offer = current_user.special_offers.find_by_slug(params[:id])
  end
  
  def update
    @special_offer = current_user.special_offers.find_by_slug(params[:id])
    if @special_offer.update_attributes(params[:special_offer])
      flash[:notice] = "Successfully updated special offer."
      redirect_to @special_offer
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @special_offer = current_user.special_offers.find_by_slug(params[:id])
    @special_offer.destroy
    flash[:notice] = "Successfully destroyed special offer."
    redirect_to special_offers_url
  end
end
