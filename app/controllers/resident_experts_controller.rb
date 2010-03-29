class ResidentExpertsController < ApplicationController
  def index
    @subcategories, @experts_for_subcategory = User.experts_for_subcategories
  end

end
