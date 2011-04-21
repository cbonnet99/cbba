class PasswordMailer < ActionMailer::Base
  include ApplicationHelper

  def forgot_password(password)
    setup_email(password.user)
    @subject << 'You have requested to change your password'
    @body[:url] = change_password_url(:reset_code => password.reset_code)
  end

  def reset_password(user)
    setup_email(user)
    @subject << 'Your password has been reset.'
  end

  protected
  
  def setup_email(user)
    default_url_options[:host] = help.site_url(user)
    default_url_options[:protocol] = APP_CONFIG[:logged_site_protocol]
    @recipients = "#{user.email}"
    @from = APP_CONFIG[:admin_email]
    @subject = "[#{APP_CONFIG[:site_name]}] "
    @sent_on = Time.now
    @body[:user] = user
  end
end