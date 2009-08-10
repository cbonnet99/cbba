class Admin::SearchResultsController < AdminApplicationController
  
  def index
    @latest_search = UserEvent.latest_search
  end
end
