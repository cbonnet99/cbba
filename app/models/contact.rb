class Contact < ActiveRecord::Base
  include Authentication
  include ContactSystem

  belongs_to :region
  belongs_to :district

  validates_presence_of :email
  validates_format_of :name, :with => RE_NAME_OK, :message => MSG_NAME_BAD, :allow_nil => true
  validates_length_of :name, :maximum => 100
  validates_uniqueness_of :email, :case_sensitive => false
  validates_format_of :email, :with => RE_EMAIL_OK, :message => MSG_EMAIL_BAD
  validates_length_of :email, :within => 6..100 #r@a.wk
  
end
