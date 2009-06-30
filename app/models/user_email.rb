class UserEmail < ActiveRecord::Base
  belongs_to :user

  named_scope :mass_emails, {:conditions => ["email_type = 'mass_email'"], :order => "created_at desc"}
  named_scope :past_membership_expirations, {:conditions => ["email_type = 'past_membership_expiration'"], :order => "created_at desc"}
  named_scope :future_membership_expirations, {:conditions => ["email_type = 'coming_membership_expiration'"], :order => "created_at desc"}
  
end
