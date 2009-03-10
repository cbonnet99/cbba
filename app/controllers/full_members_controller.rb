class FullMembersController < ApplicationController
  def index
    @members = User.published_full_members
    @counter_id = Counter.find_by_title("Full members").id
  end

end
