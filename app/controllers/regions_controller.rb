class RegionsController < ApplicationController

  def index
    @country = Country.find_by_country_code(params[:country_code]) || Country.default_country
    @regions = @country.regions
    @districts = @country.districts
    @locations = @regions + @districts
  end
	
	def districts
		region = Region.find(params[:id])
		@districts = District.find(:all, :order => "name", :conditions => ["region_id = ?", region.id] )
	end
end
