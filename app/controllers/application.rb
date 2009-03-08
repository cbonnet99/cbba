class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  include AuthenticatedSystem
  include RoleRequirementSystem

  helper :all # include all helpers, all the time
  protect_from_forgery :secret => 'b0a876313f3f9195e9bd01473bc5cd06'
  filter_parameter_logging :password, :password_confirmation
  filter_parameter_logging :card_number, :card_verification
  
  layout :find_layout

	#  before_filter :tags
  before_filter :current_category, :categories, :counters, :except => :change_category

	def get_districts_and_subcategories
    get_districts
		get_subcategories
	end
  
  def admin_required
    unless logged_in? && current_user.admin?
      access_denied
    end
  end

  def resident_expert_admin_required
    unless logged_in? && current_user.resident_expert_admin?
      access_denied
    end
  end

  def full_member_required
    unless logged_in? && current_user.full_member?
      access_denied
    end
  end

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
    @counter_id = session[:counter_id]
    if !params[:category_name].nil?
			@category = Category.find_by_name(undasherize(params[:category_name]))
      @category_id = @category.id
      session[:category_id] = @category_id
    else
      if @counter_id.blank?
        @category_id = session[:category_id] || (Category.find_by_position(1).nil? ? nil : Category.find_by_position(1).id)
        @category = Category.find(@category_id) unless @category_id.nil?
      end
		end
	end

#	def search_init
#		selected_subcategory_id = params[:what] unless params[:what].blank?
#		if params[:where].blank?
#			selected_district_id = current_user.district_id unless current_user.nil?
#		else
#			if params[:where].starts_with?("r-")
#				selected_district_id = nil
#				region_id = params[:where].split("-")[1].to_i
#			else
#				selected_district_id = params[:where].to_i
#			end
#		end
#		@what_subcategories = Subcategory.options(@category, selected_subcategory_id)
#		@where_districts = District.options(region_id, selected_district_id)
#	end

	def categories
		@categories = Category.list_categories
	end

	def counters
		@counters = Counter.all
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

