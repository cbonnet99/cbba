class Admin::SearchResultsController < AdminApplicationController
  
  def index
    @search_results = UserEvent.paginate_by_event_type(UserEvent::SEARCH, :page => params[:page], :order => "logged_at desc")
  end
end
