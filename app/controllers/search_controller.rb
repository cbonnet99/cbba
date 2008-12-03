class SearchController < ApplicationController

	def index
    @newest_articles = Article.find(:all, :conditions => "state='published'", :order => "published_at desc", :limit => $number_articles_on_homepage )
    @total_articles = Article.count(:all, :conditions => "state='published'")
	end

	def change_category
		@category = Category.find(params[:id])
    log_user_event "Change category", "", @category.name, {:category_id => @category.id }
		session[:category_id] = @category.id unless @category.nil?
		render :layout => false
	end
	
	def search
		@what = params[:what]
		@where = params[:where]
    log_user_event "Search raw", "", "what: #{@what}, where: #{@where}"
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
        log_user_event "Search with no subcategory", "category: #{@category.name}, region #{@region_id}, district: :#{@district_id}, found #{@results.size} results", {:category_id => @category.id, :region_id => @region_id, :district_id => @district_id, :results_found => @results.size }
			else
				@subcategory = Subcategory.find(params[:what])
				@results = User.search_results(nil, @subcategory.id, @region_id, @district_id, params[:page])
        log_user_event "Search with subcategory", "subcategory: #{@subcategory.name}, region #{@region_id}, district: :#{@district_id}, found #{@results.size} results", {:subcategory_id => @subcategory.id, :region_id => @region_id, :district_id => @district_id, :results_found => @results.size}
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
