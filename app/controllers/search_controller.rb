require File.dirname(__FILE__) + '/../../lib/helpers'

class SearchController < ApplicationController

  def contact
    @norma = User.find_by_email(APP_CONFIG[:norma])
    @sav = User.find_by_email(APP_CONFIG[:sav])
    @cyrille = User.find_by_email(APP_CONFIG[:cyrille])
    @megan = User.find_by_email(APP_CONFIG[:megan])
  end

  def test_layout
    render :layout => "naked", :action => "test_layout"  
  end

  def count_show_more_details
    id = params[:id].split("-").last
    logger.debug("==== in count_show_more_details, id: #{id}")
    user = User.find(id)
    logger.debug("==== in count_show_more_details, user: #{user}")
    unless user.nil?
      log_user_event UserEvent::FREE_USER_DETAILS, "", "User: #{user.email} (#{user.id})", {:visited_user_id => user.id }
    end
  end

  def search    
		begin
      if @what.blank? && @where.blank?
          logger.debug("======== EMPTY params in search")
          flash[:error] = "Please enter something in What or Where"
          redirect_back_or_default root_url
      else
        logger.debug("====== in search, @what #{@what}")
        @region = Region.from_param(@where)
        @district = District.from_param(@where)
        @category = Category.from_param(@what)
        @subcategory = Subcategory.from_param(@what)
        logger.debug("====== in search, @category: #{@category.inspect}")
        logger.debug("====== in search, @subcategory: #{@subcategory.inspect}")
        @results = User.search_results(@category ? @category.id : nil, @subcategory ? @subcategory.id : nil, @region ? @region.id : nil, @district ? @district.id : nil, params[:page])
        log_user_event UserEvent::SEARCH, "", "what: #{@what}, where: #{@where}, category: #{@category.try(:name)}, subcategory: #{@subcategory.try(:name)}, region: #{@region.try(:name)}, district: #{@district.try(:name)}, found #{@results.size} results", {:district_id => @district ? @district.id : nil, :category_id => @category ? @category.id : nil, :subcategory_id => @subcategory ? @subcategory.id : nil, :region_id => @region ? @region.id : nil, :results_found => @results.size, :what => @what, :where => @where}
        # latitude = Region::DEFAULT_NZ_LATITUDE
        # longitude = Region::DEFAULT_NZ_LONGITUDE
        # zoom = 5
        # unless @region.blank?
        #   latitude = @region.latitude.to_f
        #   longitude = @region.longitude.to_f
        #   zoom = 7
        # end
        # unless @district.blank?
        #   latitude = @district.latitude.to_f
        #   longitude = @district.longitude.to_f
        #   zoom = 11
        # end
        
        @articles = Article.find_all_by_subcategories(@subcategory) unless @subcategory.blank?        
        @articles = Article.find_all_by_subcategories(*@category.subcategories) unless @category.blank?
        
        if @results.blank?
          @selected_user = User.find_paying_member_by_name(@what)
          unless @selected_user.nil?
              redirect_to expanded_user_path(@selected_user, :what => @what, :where => @where) unless @selected_user.nil?
          end
        end
        
        # @map = GMap.new("map_div_id")
        # @map.control_init(:large_map => true, :map_type => true)
        # @map.center_zoom_init([latitude,longitude], zoom)
        # User.map_geocoded(@map, @results)
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

  def map
    @map = GMap.new("map_div_id")
    @map.control_init(:large_map => true, :map_type => true)
    @map.center_zoom_init([Region::DEFAULT_NZ_LATITUDE,Region::DEFAULT_NZ_LONGITUDE], 5)
    User.map_geocoded(@map)

  end

	def index
    # @map = GMap.new("map_div_id")
    # @map.control_init(:large_map => false, :map_type => true)
    # @map.center_zoom_init([Region::DEFAULT_NZ_LATITUDE,Region::DEFAULT_NZ_LONGITUDE], 4)
    # User.map_geocoded(@map)
    
    @newest_articles = Article.all_newest_articles
    @total_straight_articles = Article.count(:all, :conditions => "state='published'")
    @total_howto_articles = HowTo.count(:all, :conditions => "state='published'")
    @total_articles = @total_straight_articles+@total_howto_articles
    @newest_full_members = User.newest_full_members
    @total_full_members = User.count_newest_full_members
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
