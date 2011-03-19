class CountriesController < ApplicationController
  def districts
    country = Country.find(params[:id])
    @districts = country.districts.find(:all, :include => "region", :order => "regions.name, districts.name")
  end
end
