class SubcategoriesController < ApplicationController
	def show
		@subcategory = Subcategory.find(params[:id])
		@regions = Region.all
	end
end
