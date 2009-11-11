class Contact < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  include Authorization::AasmRoles
  include ContactSystem

  belongs_to :region
  belongs_to :district

  validates_presence_of :email
  validates_format_of :name, :with => RE_NAME_OK, :message => MSG_NAME_BAD, :allow_nil => true
  validates_length_of :name, :maximum => 100
  validates_uniqueness_of :email, :case_sensitive => false
  validates_format_of :email, :with => RE_EMAIL_OK, :message => MSG_EMAIL_BAD
  validates_length_of :email, :within => 6..100 #r@a.wk
  
  named_scope :wants_newsletter, :conditions => "receive_newsletter is true"

  before_validation :generate_pwd_if_blank
  
  def self.authenticate(email, password)
    u = User.find_in_state(:first, :active, :conditions => {:email => email})
    if u && u.authenticated?(password)
      return u
    else
      c = Contact.find_in_state(:first, :active, :conditions => {:email => email})
      if c && c.authenticated?(password)
        return c
      else
        return nil
      end
    end
  end
  
  def generate_pwd_if_blank
    if self.password.blank? && self.password_confirmation.blank?
      self.password = self.password_confirmation = self.class.generate_random_password
    end
  end
  
  def validate
    unless Contact.find_by_email(self.email).blank? && User.find_by_email(self.email).blank?
      errors.add(:email ,"is already in use. Please select a different one or select 'Password forgotten'.")
    end
  end

  def renew_token
    self.update_attribute(:unsubscribe_token, Digest::SHA1.hexdigest("#{email}#{Time.now}#{id}"))
  end
  
  def full_member?
    false
  end
  
end
