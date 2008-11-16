class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  include AuthenticatedSystem
  include RoleRequirementSystem

  helper :all # include all helpers, all the time
  protect_from_forgery :secret => 'b0a876313f3f9195e9bd01473bc5cd06'
  filter_parameter_logging :password, :password_confirmation
  
  layout 'main'

  before_filter :tags
  
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

