class SubcategoriesController < ApplicationController

  def index
    @subcategories = Subcategory.find(:all, :order =>:name)
    @subcategories.concat(Category.find(:all, :order =>:name))
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
          @users = User.search_results(@category.id, @subcategory.id, @region.id, nil, params[:page])  		    
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
				  @page_description = @subcategory.description
      		@users_hash = @subcategory.users_hash_by_region
      		@articles = @subcategory.last_articles(6)
			  end
			end
	end
end
