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
end