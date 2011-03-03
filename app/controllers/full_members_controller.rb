class FullMembersController < ApplicationController
  def index
    @members = User.active.published_full_members.paginate(:page => params[:page])
  end

end
