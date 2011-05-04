class SubcategoriesController < ApplicationController

  def articles
    @subcategory = Subcategory.find_by_slug(params[:id])
    @articles = @subcategory.articles.find(:all, :conditions => "state = 'published'", :order => "published_at desc", :limit => 20)
  end

  def index
    @subcategories = Subcategory.find(:all, :order =>:name)
    @subcategories.concat(Category.find(:all, :order =>:name))
    @country = Country.find_by_country_code(params[:country_code]) || Country.default_country
    @members = @country.users.full_members.published
  end

  def region
    @region = Region.find_by_slug(params[:region_slug])
    if @region.nil?
		  flash[:error]="Could not find region #{params[:region_slug]}"
		  redirect_to root_url
    else
      @category = Category.find_by_slug(params[:category_slug])
      if @category.nil?
  		  flash[:error]="Could not find category #{params[:category_slug]}"
  		  redirect_to root_url
      else
        @subcategory = Subcategory.find_by_category_id_and_slug(@category.id, params[:subcategory_slug])
        if @subcategory.nil?
    		  flash[:error]="Could not find subcategory #{params[:subcategory_slug]}"
    		  redirect_to root_url
  		  else
          @users = User.search_results(@country.id, @category.id, @subcategory.id, @region.id, nil, params[:page])  		    
  		  end
      end
    end
  end

	def show
			@category = Category.find_by_slug(params[:category_slug])
			if @category.nil?
			  flash[:error]="Could not find category #{params[:category_slug]}"
			  redirect_to root_url
			else
				@subcategory = Subcategory.find_by_category_id_and_slug(@category.id, params[:subcategory_slug])
  			if @subcategory.nil?
  			  flash[:error]="Could not find subcategory #{params[:subcategory_slug]}"
  			  redirect_to root_url
				else
				  log_user_event UserEvent::VISIT_SUBCATEGORY, "", "", {:subcategory_id => @subcategory.id, }
				  @page_description = @subcategory.description
      		@users_hash = @subcategory.users_hash_by_region(@country)
      		@articles = @subcategory.last_articles(6)
      		@featured_experts = @subcategory.resident_experts(@country)
			  end
			end
	end
end
