class Message < ActiveRecord::Base

  RE_EMAIL_NAME   = '[\w\.%\+\-]+'
  RE_DOMAIN_HEAD  = '(?:[A-Z0-9\-]+\.)+'
  RE_DOMAIN_TLD   = '(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|jobs|museum)'
  RE_EMAIL_OK     = /\A#{RE_EMAIL_NAME}@#{RE_DOMAIN_HEAD}#{RE_DOMAIN_TLD}\z/i
  MSG_EMAIL_BAD   = "should look like an email address."

  belongs_to :user

  validates_presence_of :subject, :email, :body
  validates_format_of :email, :with => RE_EMAIL_OK, :message => MSG_EMAIL_BAD  
  validates_length_of :email, :maximum => 255
  validates_length_of :phone, :maximum => 255
  validates_length_of :subject, :maximum => 255
  validates_length_of :body, :maximum => 100000
  
end
