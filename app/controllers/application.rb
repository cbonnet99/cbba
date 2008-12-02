class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  include AuthenticatedSystem
  include RoleRequirementSystem

  helper :all # include all helpers, all the time
  protect_from_forgery :secret => 'b0a876313f3f9195e9bd01473bc5cd06'
  filter_parameter_logging :password, :password_confirmation
  
  layout :find_layout

	#  before_filter :tags
  before_filter :current_category, :categories, :search_init, :except => :change_category

	def find_layout
		if params[:format] == "js"
			return false
		else
			return "main"
		end
	end

	def get_related_articles
		if params[:subcategory_id].nil?
			@articles = Article.find_all_by_subcategories(*@category.subcategories)
		else
			@articles = Article.find_all_by_subcategories(Subcategory.find(params[:subcategory_id]))
		end
	end

	def current_category
    if !params[:category_name].nil?
			@category = Category.find_by_name(undasherize(params[:category_name]))
      @category_id = @category.id
      session[:category_id] = @category_id
    else
      @category_id = session[:category_id] || (Category.find_by_position(1).nil? ? nil : Category.find_by_position(1).id)
      @category = Category.find(@category_id)
		end
	end

	def search_init
		selected_subcategory_id = params[:what] unless params[:what].blank?
		if params[:where].blank?
			selected_district_id = current_user.district_id unless current_user.nil?
		else
			if params[:where].starts_with?("r-")
				selected_district_id = nil
				region_id = params[:where].split("-")[1].to_i
			else
				selected_district_id = params[:where].to_i
			end
		end
		@what_subcategories = Subcategory.options(@category, selected_subcategory_id)
		@where_districts = District.options(region_id, selected_district_id)
	end

	def categories
		@categories = Category.list_categories
	end

  def tags
    @tags = Tag.tags(:limit => 20)  
  end

	def get_subcategories
		@subcategories = Subcategory.find(:all, :include => "category", :order => "categories.name, subcategories.name").collect {|d| [ d.full_name, d.id ]}
	end

	def get_districts
		@districts = District.find(:all, :include => "region", :order => "regions.name, districts.name").collect {|d| [ d.full_name, d.id ]}
	end

	def get_regions
		@regions = Region.find(:all, :order => "name" )
	end
protected
	def undasherize(s)
		s.gsub(/-/, ' ').capitalize
	end
end

