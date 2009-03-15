class CategoriesController < ApplicationController

	def subcategories
		@category = Category.find(params[:id])
		@subcategories = @category.subcategories
	end

  def region
    @region = Region.find_by_name(undasherize(params[:region_name]))
    @category = Category.find_by_name(undasherize(params[:category_name]))
    if @category.nil?
      logger.error("in categories controller Show, @category is nil")
    else
      @users = User.find_all_by_region_and_subcategories(@region, *@category.subcategories)
    end
  end

	def show
		if params[:category_name].nil?
			@category = Category.find(params[:id])
		end
	end
end
