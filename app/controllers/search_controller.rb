class SearchController < ApplicationController

  def fuzzy_search
		@what = params[:fuzzy_what]
		@where = params[:fuzzy_where]
    log_user_event "Search fuzzy", "", "what: #{@what}, where: #{@where}"
		begin
      if @what.blank? && @where.blank?
          logger.debug("======== EMPTY params in search")
          flash[:error] = "Please enter something in What or Where"
          redirect_back_or_default root_url
      else
        logger.debug("====== in fuzzy_search, @what #{@what}")
        @region = Region.from_param(@where)
        @district = District.from_param(@where)
        @category = Category.from_param(@what)
        @subcategory = Subcategory.from_param(@what)
        logger.debug("====== in fuzzy_search, @category: #{@category.inspect}")
        logger.debug("====== in fuzzy_search, @subcategory: #{@subcategory.inspect}")
        @results = User.search_results(@category ? @category.id : nil, @subcategory ? @subcategory.id : nil, @region ? @region.id : nil, @district ? @district.id : nil, params[:page])
        log_user_event "Fuzzy search", "category: :#{@category.try(:name)}, subcategory: :#{@subcategory.try(:name)}, region :#{@region.try(:name)}, district: :#{@district.try(:name)}, found #{@results.size} results", {:district_id => @district ? @district.id : nil, :category_id => @category ? @category.id : nil, :subcategory_id => @subcategory ? @subcategory.id : nil, :region_id => @region ? @region.id : nil, :results_found => @results.size}
      end

#      if @what.blank?
#        if @where.blank?
#          logger.debug("======== EMPTY params in search")
#          flash[:error] = "Please enter something in What or Where"
#          redirect_back_or_default root_url
#        else
#          # #this is a location search
#            @region = Region.find_by_name(@where)
#            if @region.nil?
#              @district = District.find_by_name(@where)
#              if @district.nil?
#                #TODO: full-text-search
#              else
#                @results = User.search_results(nil, nil, nil, @district.id, params[:page])
#                log_user_event "Fuzzy search with empty subcategory", "district: :#{@district.name}, found #{@results.size} results", {:district_id => @district.id, :results_found => @results.size}
#              end
#            else
#                @results = User.search_results(nil, nil, @region.id, nil, params[:page])
#                log_user_event "Fuzzy search with empty subcategory", "region #{@region.name}, found #{@results.size} results", {:region_id => @region.id, :results_found => @results.size}
#            end
#        end
#      else
#        @subcategory = Subcategory.find_by_name(@what)
#        if @subcategory.nil?
#          @category = Category.find_by_name(@what)
#          if @category.nil?
#            #can't find a category or subcategory by this name
#            #TODO: suggest close names?
#            @results = []
#          else
#            @results = User.search_results(@category.id, nil, nil, @district.id, params[:page])
#          end
#        else
#          if @where.blank?
#            # #show all results for the whole country
#          else
#            @region = Region.find_by_name(@where)
#            if @region.nil?
#              @district = District.find_by_name(@where)
#              if @district.nil?
#                #TODO: full-text-search
#              else
#                @results = User.search_results(nil, @subcategory.id, nil, @district.id, params[:page])
#                log_user_event "Fuzzy search with subcategory", "subcategory: #{@subcategory.name}, district: :#{@district.name}, found #{@results.size} results", {:subcategory_id => @subcategory.id, :district_id => @district.id, :results_found => @results.size}
#              end
#            else
#              @results = User.search_results(nil, @subcategory.id, @region.id, nil, params[:page])
#              log_user_event "Fuzzy search with subcategory", "subcategory: #{@subcategory.name}, region #{@region.name}, found #{@results.size} results", {:subcategory_id => @subcategory.id, :region_id => @region.id, :results_found => @results.size}
#            end
#          end
#        end
#      end
		rescue ActiveRecord::RecordNotFound
			@results = []
			logger.error("ActiveRecord::RecordNotFound in search, parameters: #{params.inspect}")
		end
  end

  def test
    render :layout => false 
  end

	def index
    @map = GMap.new("map_div_id")
    @map.control_init(:large_map => true, :map_type => true)
    @map.center_zoom_init([-41.3,172.5], 5)

    User.geocoded.each do |u|
      marker = GMarker.new([u.latitude, u.longitude],
       :title => u.full_name, :info_window => u.full_info)
      @map.overlay_init(marker)
    end
    
    @newest_articles = Article.all_newest_articles
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
	
	def simple_search
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
