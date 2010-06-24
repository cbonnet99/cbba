class FriendMessage < ActiveRecord::Base
  belongs_to :from_user, :class_name => "User" 
  validates_presence_of :to_email, :subject, :body
  validates_format_of :to_email, :with => Message::RE_EMAIL_OK, :message => Message::MSG_EMAIL_BAD
  validates_format_of :from_email, :with => Message::RE_EMAIL_OK, :message => Message::MSG_EMAIL_BAD, :allow_blank => true
  
  attr_protected :from_user_id
  
  ARTICLE_SUBJECT = "An article you might like"
  ARTICLE_BODY = "<p>Dear friend,<br/><br/>Here is an article that might interest you:</p><p><a href='_ARTICLE_LINK_'>_ARTICLE_LINK_</a></p><p>I have found it on <a href='http://www.beamazing.co.nz'>beamazing.co.nz</a></p>"
  
  def validate
    if from_user.nil? && from_email.blank?
      errors.add(:base, "You must enter your email address or login")
    end
  end
  
  def from
    self.from_user.nil? ? self.from_email : self.from_user.email
  end
  
  def send!
    UserMailer.deliver_friend_message(self)
    self.update_attribute(:sent_at, Time.now)
  end
end
