class RegionsController < ApplicationController
	layout false
	
	def districts
		region = Region.find(params[:id])
		@districts = District.find(:all, :conditions => ["region_id = ?", region.id] )
	end
end
