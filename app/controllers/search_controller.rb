class SearchController < ApplicationController

	def change_category
		@category = Category.find(params[:id])
		session[:category_id] = @category.id unless @category.nil?
		render :layout => false
	end
	
	def search
		@what = params[:what]
		@where = params[:where]
		begin
			# when user selects a whole region params[:where] is of form: r-342342
			if params[:where].starts_with?("r-")
				#it is a region
				@region = Region.find(params[:where].split("-")[1])
				@region_id = @region.id
			else
				@district = District.find(params[:where])
				@district_id = @district.id
			end
			if params[:what].blank?
				@category = Category.find(params[:category_id])
				@results = User.search_results(@category.id, nil, @region_id, @district_id, params[:page])
			else
				@subcategory = Subcategory.find(params[:what])
				@results = User.search_results(nil, @subcategory.id, @region_id, @district_id, params[:page])
			end
		rescue ActiveRecord::RecordNotFound
			@results = []
			logger.error("ActiveRecord::RecordNotFound in search, parameters: #{params.inspect}")
		end
	end

  def tag
    @articles = Article.for_tag(params[:id])
  end

end
