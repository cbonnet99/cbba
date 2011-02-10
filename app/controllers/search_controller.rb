require File.dirname(__FILE__) + '/../../lib/helpers'

class SearchController < ApplicationController
  protect_from_forgery :except => :search

  def main
    @profiles = UserProfile.published
    @articles = Article.published
    @gv = GiftVoucher.published
    @so = SpecialOffer.published
    @all = @profiles.concat(@articles).concat(@gv).concat(@so)
    @all = @all.sort_by(&:published_at).reverse
  end
  
  def contact
    @sav = User.find_by_email(APP_CONFIG[:sav]) || $admins.first[:email]
    @cyrille = User.find_by_email(APP_CONFIG[:cyrille]) || $admins.first[:email]
    @megan = User.find_by_email(APP_CONFIG[:megan]) || $admins.first[:email]
  end

  def count_show_more_details
    id = params[:id].split("-").last
    user = User.find(id)
    unless user.nil?
      log_bam_user_event UserEvent::FREE_USER_DETAILS, "", "User: #{user.email} (#{user.id})", {:visited_user_id => user.id }
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
        @page_description = title_search(@region, @district, @category, @subcategory)
        logger.debug("====== in search, @category: #{@category.inspect}")
        logger.debug("====== in search, @subcategory: #{@subcategory.inspect}")
        if !@subcategory.nil? && @region.nil? && @district.nil?
          @category = @subcategory.category
          redirect_to subcategory_url(@category.slug, @subcategory.slug)
        end
        @results = User.search_results(@category ? @category.id : nil, @subcategory ? @subcategory.id : nil, @region ? @region.id : nil, @district ? @district.id : nil, params[:page])
        if @results.blank?
          @selected_user = User.find_paying_member_by_name(@what)
          results_size = 1 unless @selected_user.nil?
        else
          results_size = @results.size
        end
        log_bam_user_event UserEvent::SEARCH, "", "what: #{@what}, where: #{@where}, category: #{@category.try(:name)}, subcategory: #{@subcategory.try(:name)}, region: #{@region.try(:name)}, district: #{@district.try(:name)}, found #{@results.size} results", {:district_id => @district ? @district.id : nil, :category_id => @category ? @category.id : nil, :subcategory_id => @subcategory ? @subcategory.id : nil, :region_id => @region ? @region.id : nil, :results_found => results_size, :what => @what, :where => @where}
        
        @articles = Article.search(@subcategory, @category, @district, @region)
        
        if @results.blank? && !@selected_user.nil?
            redirect_to expanded_user_url(@selected_user, :what => @what, :where => @where) unless @selected_user.nil?
        end
        
      end

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
	  @context = "homepage"
    @newest_articles = Article.all_featured_articles
    @total_straight_articles = Article.count_published
    @total_howto_articles = HowTo.count_published
    @total_articles = @total_straight_articles+@total_howto_articles
    @featured_full_members = User.featured_full_members
    @total_full_members = User.count_newest_full_members
    @featured_article = Article.first_homepage_featured
	end

	def simple_search
		@what = params[:what]
		@where = params[:where]
    log_bam_user_event "Search raw", "", "what: #{@what}, where: #{@where}"
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
        log_bam_user_event "Search with no subcategory", "category: #{@category.name}, region #{@region_id}, district: :#{@district_id}, found #{@results.size} results", {:category_id => @category.id, :region_id => @region_id, :district_id => @district_id, :results_found => @results.size }
			else
				@subcategory = Subcategory.find(params[:what])
				@results = User.search_results(nil, @subcategory.id, @region_id, @district_id, params[:page])
        log_bam_user_event "Search with subcategory", "subcategory: #{@subcategory.name}, region #{@region_id}, district: :#{@district_id}, found #{@results.size} results", {:subcategory_id => @subcategory.id, :region_id => @region_id, :district_id => @district_id, :results_found => @results.size}
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
