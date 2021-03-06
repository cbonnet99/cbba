class UserMailer < ActionMailer::Base

  include ApplicationHelper
  include ActionController::UrlWriter

  def news_digest(user, news_digest)
    setup_email(user)
    @token = user.renew_token
    if user.is_a?(User)
      @body[:url] = user_slug_action_url(:action => "unsubscribe", :slug => user.slug,  :token => @token )
    else
      @body[:url] = url_for(:controller => "contacts", :action => "unsubscribe", :id => user.id,  :token => @token )
    end
    @subject = news_digest.title
    @body[:articles] = news_digest.articles
    @content_type = 'text/html'
  end

  def users_about_to_be_deleted(admin, users_to_be_deleted)
    setup_email(admin)
    @subject = "Users will be deleted in 2 days"
    @content_type = 'text/html'
    @body[:users_to_be_deleted] = users_to_be_deleted
  end

  def user_will_be_deleted_in_1_week(user)
    setup_email(user)
    @subject = "Please confirm your profile on #{help.site_name(user)} or it will be deleted in one week"
    @content_type = 'text/html'    
    @body[:site_name] = help.site_name(user)
    @body[:url] = confirm_user_url(:activation_code => user.activation_code)
  end
  
  def inconsistent_tabs(user, res)
    setup_email(user)
    @subject = "Inconsistent tabs"    
    @res = res
  end
  
  def weekly_admin_statistics(user)
    setup_email(user)
    @subject = "BAM stats #{Time.now.to_date}"
    @content_type = 'text/html'
    @start_date = Time.now.beginning_of_week
    @end_date = Time.now.end_of_week
    @body[:payments] = Payment.find(:all, :conditions => {:created_at => @start_date..@end_date, :status => "completed"} )
    @body[:pending_payments] = Payment.find(:all, :conditions => {:created_at => @start_date..@end_date, :status => "pending"} )
    @body[:total_payments] = @body[:payments].inject(0){|sum, p| sum+p.amount} || 0
    @body[:signups] = User.find(:all, :conditions => {:created_at => @start_date..@end_date } )
    @body[:published_profiles] = UserProfile.find(:all, :conditions => {:published_at => @start_date..@end_date, :state => "published"} )
    @body[:draft_profiles] = UserProfile.find(:all, :conditions => {:created_at => @start_date..@end_date, :state => "draft"} )
    @body[:published_articles] = Article.find(:all, :conditions => {:published_at => @start_date..@end_date } )
    @body[:published_SOs] = SpecialOffer.find(:all, :conditions => {:published_at => @start_date..@end_date } )
    @body[:published_GVs] = GiftVoucher.find(:all, :conditions => {:published_at => @start_date..@end_date } )
    @body[:public_newsletter_signups] = Contact.find(:all, :conditions => {:created_at => @start_date..@end_date })
  end
  
  def new_user_confirmation_email(user)
    setup_email(user)
    @subject = "Welcome to #{help.site_name(user)}"
    @content_type = 'text/html'
    @body[:site_name] = help.site_name(user)
    if user.is_a?(User)
      @body[:url] = confirm_user_url(:activation_code => user.activation_code)
    else
      @body[:url] = confirm_contact_url(:activation_code => user.activation_code)
    end
  end
  
  def congrats_first_article(user)
    setup_email(user)
    @subject = "Your first article on BeAmazing!"
    @content_type = 'text/html'
    @body[:site_name] = help.site_name(user)
  end

  def offers_reminder(user)
    setup_email(user)
    @subject = "Make the most of your offers"
    @content_type = 'text/html'
    user.update_attribute(:offers_reminder_sent_at, Time.now)
  end

  def referral(sender, email, comment)
    default_url_options[:host] = help.site_url(sender)
    default_url_options[:protocol] = APP_CONFIG[:logged_site_protocol]
    @recipients = "#{email}"
    @reply_to = "#{sender.email}"
    @from = APP_CONFIG[:admin_email]
    @subject = "See #{sender.name} on #{help.site_name(sender)}"
    @sent_on = Time.now
    @body[:comment] = comment
    @body[:sender] = sender
    @content_type = 'text/html'
  end

  def notify_unpublished(user)
    setup_email(user)
    @content_type = 'text/html'
    @subject << "Your FREE guide is waiting for your"
    @body[:user] = user
    @body[:login_link] = new_session_url(:protocol => APP_CONFIG[:logged_site_protocol], :email => user.email)
    @body[:site_name] = help.site_name(user)
  end

  def congrats_published(user)
    setup_email(user)
    @content_type = 'text/html'
  end

  def alert_expired_features(user, feature_names)
    sav = User.find_by_email(APP_CONFIG[:sav])
    unless sav.nil?
      setup_email(sav)
      @subject << "Expired features for user #{user.name}"
  		@body[:feature_names] = feature_names
  		@body[:user] = user
    end
  end

  def alert_expiring_features(user, feature_names)
    sav = User.find_by_email(APP_CONFIG[:sav])
    unless sav.nil?
      setup_email(sav)
      @subject << "Expiring features for user #{user.name}"
  		@body[:feature_names] = feature_names
  		@body[:user] = user
    end
  end

  def alert_pending_payments(payments)
    sav = User.find_by_email(APP_CONFIG[:sav])
    unless sav.nil?
      setup_email(sav)
      @subject << "There are #{help.pluralize(payments.size, 'payment')}"
  		@body[:payments] = payments
    end
  end

  def expired_features(user, feature_names)
    setup_email(user)
    UserMailer.deliver_alert_expired_features(user, feature_names)
	  @subject << "Time to renew your payment"
		@body[:feature_names] = feature_names
		@body[:url] = user_promote_url
		@body[:site_url] = help.site_url(user)
		@body[:site_name] = help.site_name(user)
		@content_type = 'text/html'
  end

  def expiring_features(user, feature_names)
    setup_email(user)
    UserMailer.deliver_alert_expiring_features(user, feature_names)
		@subject << "Time to renew your payment"
		@body[:feature_names] = feature_names
		@body[:url] = user_promote_url
		@body[:contact_url] = contact_url
		@body[:site_url] = help.site_url(user)
		@body[:site_name] = help.site_name(user)
		@content_type = 'text/html'
  end

  def charging_card(user, feature_names, amount)
    setup_email(user)
		@subject << "Your features will be automatically renewed"
		@body[:feature_names] = feature_names
		@body[:url] = payments_url
		@body[:contact_url] = contact_url
		@body[:amount] = amount
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
		@subject << "[via #{help.site_name(message.user)}] #{message.subject}"
		@reply_to = "#{message.email}"
		body = message.body
		body << "<hr>TIP from the Be Amazing Team: &quot;Want more enquiries from <a href='#{help.site_name(message.user)}'>#{help.site_name(message.user)}</a>? Then add articles, run trial sessions and offer a gift voucher - just log-in, follow the links and increase your profile!&quot;"
		@body[:body] = body
		@body[:email] = message.email
		@body[:phone] = message.phone
    @content_type = 'text/html'
  end
  
  def friend_message(message)
    @recipients = "#{message.to_email}"
    @from = "#{message.from}"
    @sent_on = Time.now
		@subject = "[via #{help.site_name(message.from_user)}] #{message.subject}"
		@reply_to = "#{message.from}"
		body = message.body
		@body[:body] = body
    @content_type = 'text/html'
  end
  
  def free_tool(contact)
    setup_email(contact)
    @body[:site_name] = help.site_name(contact)
    @subject = "Here is your goal setting tool from #{APP_CONFIG[:site_name]}]"
    @body[:contact] = contact
    attachment :content_type => "application/pdf",
     :body => File.read(Rails.root.join("doc", "be_amazing_goal_setting_tool.pdf")),
     :filename => "be_amazing_goal_setting_tool.pdf"
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
      @body[:url] = user_slug_action_url(:action => "unsubscribe", :slug => user.slug,  :token => @token )
    else
      @body[:url] = url_for(:controller => "contacts", :action => "unsubscribe", :id => user.id,  :token => @token )
    end
		@subject << subject
		@body[:newsletter] = newsletter
		@body[:user] = user
    @content_type = 'text/html'    
  end
  
  def payment_invoice(user, payment, invoice)
    setup_email(user)
    @content_type = 'text/html'    
    @body[:payment] = payment
		@body[:url] = payments_url
    @body[:sav] = User.find_by_email(APP_CONFIG[:sav]) || $admins.first[:email]
		@body[:site_name] = help.site_name(payment.user)
		@body[:amount] = help.amount_view(payment.amount, payment.currency)
		@body[:gst] = help.amount_view(payment.gst, payment.currency)
		@body[:total] = help.amount_view(payment.total, payment.currency)
    if payment.stored_token_id.nil?
		  @subject << "Your Premium membership invoice from Zingabeam.com"
      attachment :content_type => "application/pdf",
       :body => File.read(Rails.root.join("doc", "fly_strategies.pdf")),
       :filename => "fly_strategies.pdf"
	  else
	    @subject << "Invoice for your automatic renewal from Zingabeam.com"
    end
  end

  def membership_expired_today(user)
    setup_email(user)
		@subject << "Your membership has expired"
		@body[:url] = user_renew_membership_url(:user => user)
    @content_type = 'text/html'
  end

  def past_membership_expiration(user, time_description)
    setup_email(user)
		@subject << "Your membership has expired #{time_description} ago"
		@body[:time_description] = time_description
		@body[:url] = user_renew_membership_url(:user => user)
    @content_type = 'text/html'
  end

  def coming_membership_expiration(user, time_description)
    setup_email(user)
		@subject << "Your membership will expire in #{time_description}"
		@body[:time_description] = time_description
		@body[:url] = user_renew_membership_url(:user => user)
    @content_type = 'text/html'
  end
  
  def featured_homepage_article(article)
    setup_email(article.author)
    @subject << "You're on our homepage!"
    @body[:feature_date] = Time.now.to_date
		@body[:site_name] = help.site_name(article.author)
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
		if stuff.class.to_s == "UserProfile"
		  @body[:stuff_host] = site_url(stuff.user)
	  else
		  @body[:stuff_host] = site_url(stuff.author)
    end
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
    @content_type = 'text/html'    
    @subject << 'Your BeAmazing account has been activated!'
    @body[:url] = root_url
  end
  
  protected
  
  def setup_email(user)
    default_url_options[:host] = help.site_name(user)
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
