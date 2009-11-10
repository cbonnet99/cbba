require File.dirname(__FILE__) + '/../../lib/helpers'
require 'pdf/writer'
class SpecialOffersController < ApplicationController

  before_filter :login_required, :except => [:index, :index_for_subcategory, :show]
  before_filter :get_context, :except => :index 
	after_filter :store_location, :only => [:index, :show]

  def index_for_subcategory
    @subcategory = Subcategory.find_by_slug(params[:subcategory_slug])
    @subcategory = Subcategory.first if @subcategory.nil?
    @special_offers = SpecialOffer.find_all_by_state_and_subcategory_id('published', @subcategory.id)
  end

  def index
    @context = "homepage"
    @special_offers = SpecialOffer.published
    @special_only = true
    @all_offers = @special_offers
    log_bam_user_event UserEvent::SELECT_COUNTER, "", "Special offers"
  end

	def publish
    @special_offer = current_user.find_special_offer(params[:id])
    if @special_offer.publish!
      flash[:notice] = "\"#{@special_offer.title}\" successfully published"
    else
      flash[:error] = "You can only have #{help.pluralize(current_user.max_published_special_offers, "special offer")} published at any time"      
    end
    redirect_with_context(special_offers_url)
		rescue ActiveRecord::RecordNotFound => e
			flash[:error] = "You can not publish this special offer"
      redirect_with_context(special_offers_url)
	end

	def unpublish
    @special_offer = current_user.find_special_offer(params[:id])
		@special_offer.remove!
		flash[:notice] = "\"#{@special_offer.title}\" is no longer published"
    redirect_with_context(special_offers_url)

		rescue ActiveRecord::RecordNotFound => e
			flash[:error] = "You can not unpublish this special offer"
      redirect_with_context(special_offers_url)
	end
  
  def show
    get_selected_user
    if @selected_user.nil?
      flash.now[:error]="Sorry, this special offer could not be found"
      redirect_with_context(special_offers_url)
    else
      @special_offer = @selected_user.find_special_offer_for_user(params[:id], current_user)
      if @special_offer.nil?
        flash.now[:error]="Sorry, this special offer could not be found"
        redirect_with_context(special_offers_url)
      else
        respond_to do |format|
          format.html do
          end
          format.pdf do
            send_file "#{RAILS_ROOT}/public#{@special_offer.pdf_filename}", :type => "application/pdf", :disposition => "attachment; filename=#{@special_offer.slug}.pdf" 
          end
        end
      end
    end
  end
  
  def new
    @special_offer = current_user.special_offers.new
    @special_offer.how_to_book = current_user.default_how_to_book
    @special_offer.terms = SpecialOffer::DEFAULT_TERMS
    @special_offer.subcategory_id = current_user.subcategories.first.id unless current_user.subcategories.blank?
		get_subcategories
  end
  
  def create
    if params["cancel"]
      flash[:notice]="Special offer cancelled"
      redirect_back_or_default user_special_offers_url
    else  
      @special_offer = current_user.special_offers.new(params[:special_offer])
      if @special_offer.save
        if params["save_as_draft"]
          flash[:notice] = "\"#{@special_offer.title}\" was successfully saved as a draft."
        else
          if @special_offer.publish!
            flash[:notice] = "\"#{@special_offer.title}\" was successfully saved and published."
          else
            flash[:error] = "\"#{@special_offer.title}\" was saved as a draft (you can only have #{help.pluralize(current_user.max_published_special_offers, "special offer")} published at any time)"
          end
        end
        redirect_to special_offers_show_url(@special_offer.author.slug, @special_offer.slug, :context => @context, :selected_tab_id => @selected_tab_id)
      else
        render :action => 'new'
      end
    end
  end
  
  def edit
    @special_offer = current_user.special_offers.find_by_slug(params[:id])
		get_subcategories
  end
  
  def update
    if params["cancel"]
      flash[:notice]="Special offer cancelled"
      redirect_back_or_default user_special_offers_url
    else
      @special_offer = current_user.special_offers.find_by_slug(params[:id])
      if @special_offer.update_attributes(params[:special_offer])
        flash[:notice] = "\"#{@special_offer.title}\" successfully updated."
        redirect_to special_offers_show_url(@special_offer.author.slug, @special_offer.slug, :context => @context, :selected_tab_id => @selected_tab_id)
      else
        render :action => 'edit'
      end
    end
  end
  
  def destroy
    @special_offer = current_user.special_offers.find_by_slug(params[:id])
    @title = @special_offer.title
    if current_user.author?(@special_offer)
      @special_offer.destroy
      flash[:notice] = "\"#{@title}\" was deleted"
    else
      flash[:error] = "You cannot delete this special offer"
    end
    redirect_with_context(special_offers_url)
  end
end
