class ResidentExpertsController < ApplicationController
  def index
    @experts = User.resident_experts(@country)
  end

end
