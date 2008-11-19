class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  include AuthenticatedSystem
  include RoleRequirementSystem

  helper :all # include all helpers, all the time
  protect_from_forgery :secret => 'b0a876313f3f9195e9bd01473bc5cd06'
  filter_parameter_logging :password, :password_confirmation
  
  layout :find_layout

	#  before_filter :tags
  before_filter :current_category, :categories, :search_init

	def find_layout
		if params[:format] == "js"
			return false
		else
			return "main"
		end
	end

	def current_category
		@category_id = session[:category_id] || (Category.find_by_position(1).nil? ? nil : Category.find_by_position(1).id)
	end

	def search_init
		selected_subcategory_id = params[:what] unless params[:what].blank?
		if params[:where].blank?
			selected_district_id = current_user.district_id unless current_user.nil?
		else
			selected_district_id = params[:where].to_i
		end
		@what_subcategories = Subcategory.find_all_by_category_id(@category_id,  :order => "name").inject("<option value=''>All</option>"){|memo, subcat|
			if !selected_subcategory_id.nil? && selected_subcategory_id == subcat.id
				memo << "<option value='#{subcat.id}' selected='selected'>#{subcat.name}</option>"
			else
				memo << "<option value='#{subcat.id}'>#{subcat.name}</option>"
			end
		}
		@where_districts = District.find(:all, :include => "region",  :order => "regions.name, districts.name").inject(""){|memo, d|
			if !selected_district_id.nil? && selected_district_id == d.id
				memo << "<option value='#{d.id}' selected='selected'>#{d.name}</option>"
			else
				memo << "<option value='#{d.id}'>#{d.full_name}</option>"
			end
		}
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
end

