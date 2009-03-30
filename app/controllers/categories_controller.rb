require File.dirname(__FILE__) + '/../../lib/helpers'

class CategoriesController < ApplicationController

	def subcategories
		@category = Category.find(params[:id])
		@subcategories = @category.subcategories
	end

  def region
    @region = Region.find_by_name(help.undasherize_capitalize(params[:region_name]))
    @category = Category.find_by_name(help.undasherize(params[:category_name]))
    if @category.nil?
      logger.error("in categories controller Show, @category is nil")
    else
      @users = User.search_results(@category.id, nil, @region.id, nil, params[:page])
    end
  end

	def show
		if params[:category_name].nil?
			@category = Category.find(params[:id])
		end
	end
end
