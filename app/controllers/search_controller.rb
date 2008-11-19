class SearchController < ApplicationController

	def change_category
		@category = Category.find(params[:id])
		session[:category_id] = @category.id unless @category.nil?
		render :layout => false
	end
	
	def search
		begin
		@district = District.find(params[:where])
		if params[:what].blank?
			@category = Category.find(params[:category_id])
			@results = User.search_results(@category.id, nil, @district.id)
		else
			@subcategory = Subcategory.find(params[:what])
			@results = User.search_results(nil, @subcategory.id, @district.id)
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
