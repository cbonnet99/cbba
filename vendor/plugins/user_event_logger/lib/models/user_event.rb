class UserEvent < ActiveRecord::Base
	belongs_to :user
	belongs_to :visited_user, :class_name => "User"
	belongs_to :article
	belongs_to :category
	belongs_to :subcategory
	belongs_to :region
	belongs_to :district

	named_scope :login, :conditions => ["event_type='Login'"]
	named_scope :for_session, lambda { |session| {:conditions => ["session = ?", session] }}
  named_scope :no_results, :conditions => "results_found=0"
  named_scope :excludes_own, :conditions => "user_id IS NULL OR user_id <> visited_user_id"
  named_scope :for_week_around_date, lambda {|date| {:conditions => ["logged_at BETWEEN ? AND ?", date.beginning_of_week, date.end_of_week]}}
  named_scope :last_30_days, :conditions => ["logged_at BETWEEN ? AND ?", 30.days.ago, Time.now]
  named_scope :last_12_months, :conditions => ["logged_at BETWEEN ? AND ?", 12.months.ago, Time.now]
  
  MSG_SENT = "Message sent"
  FRIEND_MSG_SENT = "Message sent to a friend"
  FREE_USER_DETAILS = "Free user show details"
  SEARCH = "Search"
  SELECT_CATEGORY = "Select category"
  SELECT_COUNTER = "Select counter"
  VISIT_PROFILE = "Visit full member profile"
  REDIRECT_WEBSITE = "Redirected to website"
  VERIFY_CATPCHA = "Verify captcha"
  LOGIN = "Login"
  ADMIN_LOGIN = "Admin login"
  USER_DEACTIVATED = "User deactivated"
  USER_REACTIVATED = "User reactivated"
  STARTED_PAYMENT = "Started payment"
  PAYMENT_SUCCESS = "Payment successful"
  PAYMENT_FAILURE = "Payment failed"
  VISIT_SUBCATEGORY = "Visit subcategory"
  
  NEVER_DELETED_EVENTS = [VISIT_PROFILE, REDIRECT_WEBSITE, MSG_SENT, PAYMENT_SUCCESS, PAYMENT_FAILURE]
  
	named_scope :free_users_show_details, :conditions => ["event_type=?", UserEvent::FREE_USER_DETAILS]
	named_scope :redirect_website, :conditions => ["event_type=?", UserEvent::REDIRECT_WEBSITE]
	named_scope :visited_profile, :conditions => ["event_type=?", UserEvent::VISIT_PROFILE]
	named_scope :received_message, :conditions => ["event_type=?", UserEvent::MSG_SENT]
	
  def user_name
    if user.nil?
      res = "Anonymous"
      res << " (#{session[0..6]})" unless session.nil?
    else
      res = user.name
    end
    res
  end
  
  def self.per_page
    20
  end
end