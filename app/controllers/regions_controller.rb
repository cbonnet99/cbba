class RegionsController < ApplicationController

  def index
    @regions = Region.find(:all, :order => "name" )
    @districts = District.find(:all, :order => "name" )
    @locations = @regions + @districts
    @locations = @locations.sort_by(&:name)
  end
	
	def districts
		region = Region.find(params[:id])
		@districts = District.find(:all, :order => "name", :conditions => ["region_id = ?", region.id] )
	end
end
