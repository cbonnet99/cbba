class SubcategoriesController < ApplicationController
	def show
		@subcategory = Subcategory.find(params[:id])
		get_regions
	end
end
