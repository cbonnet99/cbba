class FullMembersController < ApplicationController
  def index
    @members = @country.users.active.published_full_members.paginate(:page => params[:page])
  end

end
