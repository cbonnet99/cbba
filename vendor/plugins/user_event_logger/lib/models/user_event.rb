class UserEvent < ActiveRecord::Base
	belongs_to :user
	belongs_to :visited_user, :class_name => "User"
	belongs_to :article
	belongs_to :category
	belongs_to :subcategory
	belongs_to :region
	belongs_to :district

	named_scope :login, :conditions => ["event_type='Login'"]
	named_scope :free_users_show_details, :conditions => ["event_type='Free user show details'"]
	named_scope :for_session, lambda { |session| {:conditions => ["session = ?", session] }}
  named_scope :no_results, :conditions => "results_found=0"
  
  MSG_SENT = "Message sent"
  FREE_USER_DETAILS = "Free user show details"
  SEARCH = "Search"
  SELECT_CATEGORY = "Select category"
  SELECT_COUNTER = "Select counter"
  VISIT_PROFILE = "Visit full member profile"
  REDIRECT_WEBSITE = "Redirected to website"
  VERIFY_CATPCHA = "Verify captcha"
  LOGIN = "Login"
  ADMIN_LOGIN = "Admin login"
  USER_DELETED = "User deleted"
  STARTED_PAYMENT = "Started payment"
  PAYMENT_SUCCESS = "Payment successful"
  PAYMENT_FAILURE = "Payment failed"
  VISIT_SUBCATEGORY = "Visit subcategory"
  
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