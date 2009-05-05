class ResidentExpertsController < ApplicationController
  def index
    @experts = User.published_resident_experts
  end

end
