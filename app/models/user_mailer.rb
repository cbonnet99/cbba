class UserMailer < ActionMailer::Base
	def article_rejected(article, author)
    setup_email(author)
		@subject << "Your article must be revised for publication"
		@body[:article] = article
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
  end
end
