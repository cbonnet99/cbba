class UserEmail < ActiveRecord::Base
  belongs_to :user
  belongs_to :mass_email
  belongs_to :contact
  belongs_to :newsletter
  belongs_to :news_digest
  
  SEND_IN_BATCH = 15
  
  named_scope :mass_emails, {:conditions => ["email_type = 'mass_email'"], :order => "created_at desc"}
  named_scope :past_membership_expirations, {:conditions => ["email_type = 'past_membership_expiration'"], :order => "created_at desc"}
  named_scope :future_membership_expirations, {:conditions => ["email_type = 'coming_membership_expiration'"], :order => "created_at desc"}
  named_scope :not_sent, {:conditions => ["sent_at IS NULL"]}
  
  def self.check_and_send_mass_emails
    UserEmail.not_sent.mass_emails.find(:all, :limit => SEND_IN_BATCH).each do |ue|
      my_user = ue.user || ue.contact
      if ue.newsletter
        UserMailer.deliver_mass_email_newsletter(my_user, ue.subject, ue.newsletter)
      else
        if ue.news_digest
          UserMailer.deliver_news_digest(my_user, ue.news_digest)
        else
          UserMailer.deliver_mass_email(my_user, ue.subject, ue.body)
        end
      end
      ue.update_attribute(:sent_at, Time.now)
    end
  end
  
end
