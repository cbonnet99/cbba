class Admin::UsersControllerController < ApplicationController
  
  def search
    search_term = "%#{params[:search_term]}%"
    @users = User.find_by_sql("SELECT u.* from users u where first_name LIKE '?' or last_name LIKE '?' or email LIKE '?'", search_term, search_term, search_term)
  end
  
end
