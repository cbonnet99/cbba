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
  named_scope :search, :conditions => "event_type='Fuzzy search'"
  named_scope :no_results, :conditions => "results_found=0"
  
  MSG_SENT = "Message sent"
  FREE_USER_DETAILS = "Free user show details"
  SEARCH = "Search"
  SELECT_CATEGORY = "Select category"
  SELECT_COUNTER = "Select counter"
  VISIT_PROFILE = "Visit full member profile"
  REDIRECT_WEBSITE = "Redirected to website"
  VERIFY_CATPCHA = "Verify captcha"
end