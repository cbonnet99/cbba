class RegionsController < ApplicationController
	
	def districts
		region = Region.find(params[:id])
		@districts = District.find(:all, :order => "name", :conditions => ["region_id = ?", region.id] )
	end
end
