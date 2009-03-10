class ResidentExpertsController < ApplicationController
  def index
    @experts = User.published_resident_experts
    @counter_id = Counter.find_by_title("Resident experts").id
  end

end
