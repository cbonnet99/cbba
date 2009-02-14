class SubcategoriesController < ApplicationController

  def index
    @subcategories = Subcategory.find(:all, :order =>:name)
  end

	def show
		if params[:category_name].nil? || params[:subcategory_name].nil?
			@subcategory = Subcategory.find(params[:id])
		else
			@category = Category.find_by_name(undasherize(params[:category_name]))
			if @category.nil?
				logger.error("in Subcategories controller Show, @category is nil")
			else
				@subcategory = Subcategory.find_by_category_id_and_name(@category.id, undasherize(params[:subcategory_name]))
			end
		end
		get_regions
	end
end
