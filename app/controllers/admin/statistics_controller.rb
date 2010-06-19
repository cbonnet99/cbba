class Admin::StatisticsController < ApplicationController
  def index
    @date = params[:date].blank? ? Time.now : Time.parse(params[:date])
    @start_date = @date.beginning_of_week
    @end_date = @date.end_of_week
    p = Payment.find(:all, :conditions => {:created_at => @start_date..@end_date } )
    @payments = p.size
    @total_payments = p.inject(0){|sum, p| sum+p.amount}
    @signups = User.count(:all, :conditions => {:created_at => @start_date..@end_date } )
    @published_profiles = UserProfile.count(:all, :conditions => {:published_at => @start_date..@end_date } )
    @published_articles = Article.count(:all, :conditions => {:published_at => @start_date..@end_date } )
    @published_SOs = SpecialOffer.count(:all, :conditions => {:published_at => @start_date..@end_date } )
    @published_GVs = GiftVoucher.count(:all, :conditions => {:published_at => @start_date..@end_date } )
  end
end
