class SearchController < ApplicationController

  def fuzzy_search
		@what = params[:fuzzy_what]
		@where = params[:fuzzy_where]
    log_user_event "Search fuzzy", "", "what: #{@what}, where: #{@where}"
		begin
      if @what.blank?
        if @where.blank?
          flash[:error] = "Please enter something in What or Where"
        else
          # #this is a location search
        end
      else
        @subcategory = Subcategory.find_by_name(@what)
        if @subcategory.nil?
          # #guess a close match
        else
          if @where.blank?
            # #show all results for the whole country
          else
            @region = Region.find_by_name(@where)
            if @region.nil?
              @district = District.find_by_name(@where)
              if @district.nil?
              else
                @results = User.search_results(nil, @subcategory.id, nil, @district.id, params[:page])
                log_user_event "Fuzzy search with subcategory", "subcategory: #{@subcategory.name}, region #{@region_id}, district: :#{@district_id}, found #{@results.size} results", {:subcategory_id => @subcategory.id, :district_id => @district.id, :results_found => @results.size}
              end
            else
              @results = User.search_results(nil, @subcategory.id, @region.id, nil, params[:page])
              log_user_event "Fuzzy search with subcategory", "subcategory: #{@subcategory.name}, region #{@region_id}, district: :#{@district_id}, found #{@results.size} results", {:subcategory_id => @subcategory.id, :region_id => @region.id, :results_found => @results.size}
            end
          end
        end
      end
		rescue ActiveRecord::RecordNotFound
			@results = []
			logger.error("ActiveRecord::RecordNotFound in search, parameters: #{params.inspect}")
		end
  end

  def test
    render :layout => false 
  end

	def index
    @newest_straight_articles = Article.find(:all, :conditions => "state='published'", :order => "published_at desc", :limit => $number_articles_on_homepage )
    @newest_howto_articles = HowTo.find(:all, :conditions => "state='published'", :order => "published_at desc", :limit => $number_articles_on_homepage )
    @newest_articles = @newest_straight_articles + @newest_howto_articles
    @newest_articles = @newest_articles.sort_by(&:published_at)
    @newest_articles.reverse!
    @newest_articles = @newest_articles[0..$number_articles_on_homepage-1]
    @total_straight_articles = Article.count(:all, :conditions => "state='published'")
    @total_howto_articles = HowTo.count(:all, :conditions => "state='published'")
    @total_articles = @total_straight_articles+@total_howto_articles
    @newest_full_members = User.newest_full_members
    @total_full_members = User.count_newest_full_members
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
        # #it is a region
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
