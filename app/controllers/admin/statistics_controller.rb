class Admin::StatisticsController < ApplicationController
  def index
    @date = params[:date].blank? ? Time.now : Time.parse(params[:date])
    @start_date = @date.beginning_of_week
    @end_date = @date.end_of_week
    @payments = Payment.find(:all, :conditions => {:created_at => @start_date..@end_date, :status => "completed"} )
    @pending_payments = Payment.find(:all, :conditions => {:created_at => @start_date..@end_date, :status => "pending"} )
    @total_payments = @payments.inject(0){|sum, p| sum+p.amount} || 0
    @signups = User.find(:all, :conditions => {:created_at => @start_date..@end_date } )
    @published_profiles = UserProfile.find(:all, :conditions => {:published_at => @start_date..@end_date, :state => "published"} )
    @draft_profiles = UserProfile.find(:all, :conditions => {:created_at => @start_date..@end_date, :state => "draft"} )
    @published_articles = Article.count(:all, :conditions => {:published_at => @start_date..@end_date } )
    @published_SOs = SpecialOffer.count(:all, :conditions => {:published_at => @start_date..@end_date } )
    @published_GVs = GiftVoucher.count(:all, :conditions => {:published_at => @start_date..@end_date } )
    @public_newsletter_signups = Contact.count(:all, :conditions => {:created_at => @start_date..@end_date })
  end
end
