class UserMailer < ActionMailer::Base

  include ApplicationHelper

  def approve_expert(user, expert_application)
    setup_email(user)
		@subject << "Your expert application has been approved"
    @body[:expert_application] = expert_application
		@body[:url] = edit_payment_path(expert_application.payment)
  end

  def notifiy_admin_new_expert_application(expert_application, user)
    setup_email(user)
		@subject << "New expert application"
    @body[:expert_application] = expert_application
		@body[:url] = expert_applications_action_with_id_path(expert_application, :action => "show")
  end

  def payment_invoice(user, payment, invoice)
    setup_email(user)
		@subject << "Invoice for your payment"
    @body[:payment] = payment
		@body[:url] = payments_path
    attachment :content_type => "application/pdf",
     :body => invoice.pdf,
     :filename => invoice.filename

  end

  def membership_expired_today(user)
    setup_email(user)
		@subject << "Your membership has expired"
		@body[:url] = user_renew_membership_path(:user => user)
  end

  def past_membership_expiration(user, time_description)
    setup_email(user)
		@subject << "Your membership has expired #{time_description} ago"
		@body[:time_description] = time_description
		@body[:url] = user_renew_membership_path(:user => user)
  end

  def coming_membership_expiration(user, time_description)
    setup_email(user)
		@subject << "Your membership will expire in #{time_description}"
		@body[:time_description] = time_description
		@body[:url] = user_renew_membership_path(:user => user)
  end

	def item_rejected(item, author)
    setup_email(author)
		@subject << "Your #{item.class.to_s.titleize.downcase} must be revised for publication"
    path_method = self.method(item.path_method.to_sym)
    if path_method.nil?
      logger.error("No method called #{item.path_method} could be found in object: #{self.inspect}")
    else
      @body[:path_method] = path_method
    end

		@body[:item] = item
	end
	def stuff_to_review(stuff, reviewer)
    setup_email(reviewer)
		@subject << "Review needed"
		@body[:stuff] = stuff
    path_method = self.method(stuff.path_method.to_sym)
    if path_method.nil?
      logger.error("No method called #{stuff.path_method} could be found in object: #{self.inspect}")
    else
      @body[:path_method] = path_method
    end
	end
  def signup_notification(user)
    setup_email(user)
    @subject << 'Please activate your new account with BeAmazing.com'
    @body[:url] = "#{APP_CONFIG[:site_url]}/activate/#{user.activation_code}"
  end
  
  def activation(user)
    setup_email(user)
    @subject << 'Your BeAmazing account has been activated!'
    @body[:url] = APP_CONFIG[:site_url]
  end
  
  protected
  
  def setup_email(user)
    @recipients = "#{user.email}"
    @from = APP_CONFIG[:admin_email]
    @subject = "[#{APP_CONFIG[:site_name]}] "
    @sent_on = Time.now
    @body[:user] = user
    #record that an email was sent
    UserEmail.create(:user => user, :email_type => caller_method_name )
  end
def caller_method_name
    parse_caller(caller(2).first).last
end

def parse_caller(at)
    if /^(.+?):(\d+)(?::in `(.*)')?/ =~ at
        file = Regexp.last_match[1]
		line = Regexp.last_match[2].to_i
		method = Regexp.last_match[3]
		[file, line, method]
	end
end
end
