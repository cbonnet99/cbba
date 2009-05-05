class FullMembersController < ApplicationController
  def index
    @members = User.published_full_members
  end

end
