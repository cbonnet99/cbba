class ResidentExpertsController < ApplicationController
  def index
    @experts = User.resident_experts.active
  end

end
