class UserMailer < ActionMailer::Base

  include ApplicationHelper
  include ActionController::UrlWriter

  def referral(sender, email, comment)
    default_url_options[:host] = APP_CONFIG[:site_host]
    default_url_options[:protocol] = APP_CONFIG[:logged_site_protocol]
    @recipients = "#{email}"
    @reply_to = "#{sender.email}"
    @from = APP_CONFIG[:admin_email]
    @subject = "See #{sender.name} on beamazing.co.nz"
    @sent_on = Time.now
    @body[:comment] = comment
    @body[:sender] = sender
    @content_type = 'text/html'
  end

  def congrats_published(user)
    setup_email(user)
    @content_type = 'text/html'
  end

  def alert_expired_features(user, feature_names)
    megan = User.find_by_email(APP_CONFIG[:megan])
    unless megan.nil?
      setup_email(megan)
      @subject << "Expired features for user #{user.name}"
  		@body[:feature_names] = feature_names
  		@body[:user] = user
    end
  end

  def alert_expiring_features(user, feature_names)
    megan = User.find_by_email(APP_CONFIG[:megan])
    unless megan.nil?
      setup_email(megan)
      @subject << "Expiring features for user #{user.name}"
  		@body[:feature_names] = feature_names
  		@body[:user] = user
    end
  end

  def alert_pending_payments(payments)
    megan = User.find_by_email(APP_CONFIG[:megan])
    unless megan.nil?
      setup_email(megan)
      @subject << "There are #{help.pluralize(payments.size, 'payment')}"
  		@body[:payments] = payments
    end
  end

  def has_expired_features(user, feature_names)
    setup_email(user)
	  @subject << "Renew anytime"
		@body[:feature_names] = feature_names
		@body[:url] = user_promote_url
  end

  def expired_features(user, feature_names)
    setup_email(user)
    UserMailer.deliver_alert_expired_features(user, feature_names)
	  @subject << "Time to renew your payment"
		@body[:feature_names] = feature_names
		@body[:url] = user_promote_url
  end

  def expiring_features(user, feature_names)
    setup_email(user)
    UserMailer.deliver_alert_expiring_features(user, feature_names)
		@subject << "Time to renew your payment"
		@body[:feature_names] = feature_names
		@body[:url] = user_promote_url
		@body[:contact_url] = contact_url
		@content_type = 'text/html'
  end
  
  def thank_you_direct_debit(user, payment)
    setup_email(user)
		@subject << "Your direct debit details for BeAmazing"
		@body[:payment] = payment
		@body[:credit_card_url] = payment_action_with_id_url(:action => "edit", :id => payment.id)
  end

  def message(message)
    setup_email(message.user)
		@subject << "[via beamazing.co.nz] #{message.subject}"
		@reply_to = "#{message.email}"
		body = message.body
		body << "<hr>TIP from the Be Amazing Team: &quot;Want more enquiries from <a href='#{APP_CONFIG[:site_host]}'>beamazing.co.nz</a>? Then add articles, run special offers and offer a gift voucher - just log-in, follow the links and increase your profile!&quot;"
		@body[:body] = body
		@body[:email] = message.email
		@body[:phone] = message.phone
    @content_type = 'text/html'
  end
  
  def mass_email(user, subject, body)
    setup_email(user)
		@subject << subject
		@body[:body] = body
		@body[:user] = user
		if user.full_member? && !user.main_expertise_slug.blank?
		  @body[:profile_url] = expanded_user_url(user)
	  else
	    @body[:profile_url] = ""
    end
    @content_type = 'text/html'
  end

  def mass_email_newsletter(user, subject, newsletter)
    setup_email(user)
    @token = user.renew_token
    if user.is_a?(User)
      @body[:url] = user_slug_action_url(:action => "unsubscribe", :slug => user.slug,  :unsubscribe_token => @token )
    else
      @body[:url] = url_for(:controller => "contacts", :action => "unsubscribe", :id => user.id,  :unsubscribe_token => @token )
    end
		@subject << subject
		@body[:newsletter] = newsletter
		@body[:user] = user
    @content_type = 'text/html'    
  end
  
  def approve_expert(user, expert_application)
    setup_email(user)
		@subject << "Your expert application has been approved"
    @body[:expert_application] = expert_application
		@body[:url] = edit_payment_url(expert_application.payment)
  end

  def expert_application_time_out(user, expert_application)
    setup_email(user)
		@subject << "Your expert application has timed out"
    @body[:expert_application] = expert_application
		@body[:url] = edit_expert_application_url(expert_application)
  end

  def notifiy_admin_new_expert_application(expert_application, user)
    setup_email(user)
		@subject << "New expert application"
    @body[:expert_application] = expert_application
		@body[:url] = expert_applications_action_with_id_url(expert_application, :action => "show")
  end

  def payment_invoice(user, payment, invoice)
    setup_email(user)
		@subject << "Invoice for your payment"
    @body[:payment] = payment
		@body[:url] = payments_url
    attachment :content_type => "application/pdf",
     :body => invoice.pdf,
     :filename => invoice.filename
  end

  def membership_expired_today(user)
    setup_email(user)
		@subject << "Your membership has expired"
		@body[:url] = user_renew_membership_url(:user => user)
    @content_type = 'text/html'
  end

  def residence_expired_today(user)
    setup_email(user)
		@subject << "Your residence has expired"
		@body[:url] = user_renew_resident_url(:user => user)
    @content_type = 'text/html'
  end

  def past_membership_expiration(user, time_description)
    setup_email(user)
		@subject << "Your membership has expired #{time_description} ago"
		@body[:time_description] = time_description
		@body[:url] = user_renew_membership_url(:user => user)
    @content_type = 'text/html'
  end

  def past_residence_expiration(user, time_description)
    setup_email(user)
		@subject << "Your membership has expired #{time_description} ago"
		@body[:time_description] = time_description
		@body[:url] = user_renew_resident_url(:user => user)
    @content_type = 'text/html'
  end

  def coming_membership_expiration(user, time_description)
    setup_email(user)
		@subject << "Your membership will expire in #{time_description}"
		@body[:time_description] = time_description
		@body[:url] = user_renew_membership_url(:user => user)
    @content_type = 'text/html'
  end

  def coming_residence_expiration(user, time_description)
    setup_email(user)
		@subject << "Your membership will expire in #{time_description}"
		@body[:time_description] = time_description
		@body[:url] = user_renew_resident_url(:user => user)
    @content_type = 'text/html'
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
    @body[:url] = activate_url(:activation_code => user.activation_code)
  end
  
  def activation(user)
    setup_email(user)
    @subject << 'Your BeAmazing account has been activated!'
    @body[:url] = root_url
  end
  
  protected
  
  def setup_email(user)
    default_url_options[:host] = APP_CONFIG[:site_host]
    default_url_options[:protocol] = APP_CONFIG[:logged_site_protocol]
    @recipients = "#{user.email}"
    @from = APP_CONFIG[:admin_email]
    @subject = "[#{APP_CONFIG[:site_name]}] "
    @sent_on = Time.now
    @body[:user] = user
    #record that an email was sent (except for mass emails)
    if user.is_a?(User) && caller_method_name != "mass_email"
      UserEmail.create(:user => user, :email_type => caller_method_name, :sent_at => Time.now)
    end
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
