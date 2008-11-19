class CategoriesController < ApplicationController

	def subcategories
		@category = Category.find(params[:id])
		@subcategories = @category.subcategories
	end
end
