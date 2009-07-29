require File.dirname(__FILE__) + '/../test_helper'

class UserEmailTest < ActiveSupport::TestCase
  fixtures :all

  def setup
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []    
  end
  
  def test_check_and_send_mass_emails
    UserEmail.check_and_send_mass_emails
    assert_equal 2, ActionMailer::Base.deliveries.size
  end
  
  def test_check_and_send_mass_emails_max
    (UserEmail::SEND_IN_BATCH+2).times {|x| UserEmail.create(:user  => users(:cyrille), :email_type  =>  "mass_email",
      :mass_email  =>  mass_emails(:test_email), :subject  =>  "Hello", :body  =>  "blabla")}
    UserEmail.check_and_send_mass_emails
    
    #only the max size number of emails should be sent
    assert_equal UserEmail::SEND_IN_BATCH, ActionMailer::Base.deliveries.size
  end  

end
