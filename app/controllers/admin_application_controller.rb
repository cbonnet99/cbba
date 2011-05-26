class AdminApplicationController < SecureApplicationController
  
  before_filter :admin_required
  
  protected
    
  def get_selected_user
    @selected_user = User.find_by_slug(params[:id])
  end

end