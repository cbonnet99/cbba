class CategoriesController < ApplicationController

	def subcategories
		@category = Category.find(params[:id])
		@subcategories = @category.subcategories
	end
	def show
		if params[:category_name].nil?
			@category = Category.find(params[:id])
		else
			@category = Category.find_by_name(undasherize(params[:category_name]))
		end
	end
end
