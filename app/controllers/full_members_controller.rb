class FullMembersController < ApplicationController
  def index
    @members = User.active.published_full_members
  end

end
