require File.dirname(__FILE__) + '/../../lib/helpers'

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
  before_filter :current_category, :categories, :counters, :resident_experts, :except => :change_category

  def get_selected_user
    @selected_user = User.find_by_slug(params[:selected_user])
  end

  def verify_human
    if session[:verify_human_count].blank? || session[:verify_human_count] > 10
      my_test = verify_recaptcha
      if my_test
        session[:verify_human_count] = 1
      else
        logger.debug("=== failed captcha with response: #{params[:recaptcha_response_field]}")
      end
      return my_test
    else
      session[:verify_human_count] += 1
      return true
    end
  end

  def resident_experts
    @resident_experts = User.published_resident_experts
  end

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
			return "michael_main"
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
    if !params[:category_slug].nil?
			@category = Category.find_by_slug(params[:category_slug])
      if @category.nil?
  		  flash[:error]="Could not find category #{params[:category_slug]}"
  		  redirect_to root_url
      else
			  @category_id = @category.id
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
		@counters = Counter.published
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
end

