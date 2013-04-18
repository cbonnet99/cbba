class CountriesController < ApplicationController
  def regions
    country = Country.find(params[:id])
    @regions = country.regions.find(:all, :order => "name")
  end
end
