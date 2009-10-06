require File.dirname(__FILE__) + '/../../lib/helpers'

class CategoriesController < ApplicationController

	def subcategories
		@category = Category.find(params[:id])
		@subcategories = @category.subcategories
	end

  def region
    @region = Region.find_by_slug(params[:region_slug])
    if @region.nil?
		  flash[:error]="Could not find region #{params[:region_slug]}"
		  redirect_to root_url
    else
      @category = Category.find_by_slug(params[:category_slug])
      if @category.nil?
  		  flash[:error]="Could not find category #{params[:category_slug]}"
  		  redirect_to root_url
      else
        @users = User.search_results(@category.id, nil, @region.id, nil, params[:page])
      end
    end
  end

	def show
    log_bam_user_event UserEvent::SELECT_CATEGORY, "", @category.name, {:category_id => @category.id }		
	end
end
