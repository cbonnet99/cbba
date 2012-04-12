class Admin::StatisticsController < AdminApplicationController
  def index
    @date = params[:date].blank? ? Time.now : Time.parse(params[:date])
    @start_date = @date.beginning_of_week
    @end_date = @date.end_of_week
    get_stats
  end
end
