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
    if @special_offer.publish!
      flash[:notice] = "Special offer successfully published"
    else
      flash[:error] = "You can only have #{help.pluralize(current_user.max_published_special_offers, "special offer")} published at any time"      
    end
    redirect_back_or_default special_offers_show_path(@special_offer.author.slug, @special_offer.slug)
		rescue ActiveRecord::RecordNotFound => e
			flash[:error] = "You can not publish this special offer"
      redirect_back_or_default special_offers_show_path(@special_offer.author.slug, @special_offer.slug)
	end

	def unpublish
    @special_offer = current_user.special_offers.find(params[:id])
		@special_offer.remove!
		flash[:notice] = "Special offer is no longer published"
    redirect_back_or_default special_offers_show_path(@special_offer.author.slug, @special_offer.slug)

		rescue ActiveRecord::RecordNotFound => e
			flash[:error] = "You can not unpublish this special offer"
      redirect_back_or_default special_offers_show_path(@special_offer.author.slug, @special_offer.slug)
	end

  def index
    @special_offers = current_user.special_offers.all
  end
  
  def show
    get_selected_user
    if @selected_user.nil?
      flash[:error]="Sorry, this gift voucher could not be found"
      if params[:index_public] == "true"
        redirect_to special_offers_index_public_path
      else
        redirect_to user_special_offers_path
      end
    else
      @special_offer = @selected_user.find_special_offer_for_user(params[:id], current_user)
      if @special_offer.nil?
        flash[:error]="Sorry, this special offer could not be found"
        if params[:index_public] == "true"
          redirect_to special_offers_index_public_path
        else
          redirect_to user_special_offers_path
        end        
      end      
    end
  end
  
  def new
    @special_offer = current_user.special_offers.new
    @special_offer.how_to_book = current_user.default_how_to_book
    @special_offer.terms = SpecialOffer::DEFAULT_TERMS
  end
  
  def create
    if params["cancel"]
      flash[:notice]="Special offer cancelled"
      redirect_back_or_default user_special_offers_path
    else  
      @special_offer = current_user.special_offers.new(params[:special_offer])
      if @special_offer.save
        if params["save_as_draft"]
          flash[:notice] = 'Your draft special offer was successfully saved.'
        else
          if @special_offer.publish!
            flash[:notice] = 'Your special offer was successfully saved and published.'
          else
            flash[:error] = "Your special offer was saved as draft (you can only have #{help.pluralize(current_user.max_published_special_offers, "special offer")} published at any time)"
          end
        end
        redirect_to special_offers_show_path(@special_offer.author.slug, @special_offer.slug)
      else
        render :action => 'new'
      end
    end
  end
  
  def edit
    @special_offer = current_user.special_offers.find_by_slug(params[:id])
  end
  
  def update
    if params["cancel"]
      flash[:notice]="Special offer cancelled"
      redirect_back_or_default user_special_offers_path
    else
      @special_offer = current_user.special_offers.find_by_slug(params[:id])
      if @special_offer.update_attributes(params[:special_offer])
        flash[:notice] = "Successfully updated special offer."
        redirect_to special_offers_show_path(@special_offer.author.slug, @special_offer.slug)
      else
        render :action => 'edit'
      end
    end
  end
  
  def destroy
    @special_offer = current_user.special_offers.find_by_slug(params[:id])
    @special_offer.destroy
    flash[:notice] = "Successfully destroyed special offer."
    redirect_to special_offers_url
  end
end
