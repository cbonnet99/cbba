class CategoriesController < ApplicationController

	def subcategories
		@category = Category.find(params[:id])
		@subcategories = @category.subcategories
	end
	def show
		if params[:category_name].nil?
			@category = Category.find(params[:id])
		end
	end
end
