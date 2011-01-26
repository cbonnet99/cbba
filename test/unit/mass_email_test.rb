require File.dirname(__FILE__) + '/../test_helper'

class MassEmailTest < ActiveSupport::TestCase
  fixtures :all

  def test_deliver
    old_size = UserEmail.all.size
    
    test_password = mass_emails(:test_password)
    test_password.recipients = 'Full members'
    test_password.deliver(users(:cyrille))
    assert_equal old_size+User.active.full_members.size, UserEmail.all.size
    list_sent = test_password.sent_to.split("<br/>").reject{|e| e.blank?}
    assert_equal list_sent, User.active.full_members.map(&:name_with_email) 
  end
  
  def test_deliver_newsletter
    UserEmail.check_and_send_mass_emails
    assert_equal 0, UserEmail.not_sent.size, "UserEmail.not_sent: #{UserEmail.not_sent.inspect}"
    email_public_newsletter = mass_emails(:email_public_newsletter)
    email_public_newsletter.recipients = "All subscribers"
    email_public_newsletter.deliver(users(:cyrille))
    assert_equal User.active.wants_newsletter.size+Contact.wants_newsletter.size, UserEmail.not_sent.size
  end

  def test_unknown_attributes
    assert_equal ["bla"], mass_emails(:unknown_attributes).unknown_attributes(users(:cyrille))
  end

  def test_transformed_body
    assert_equal "This is 10% my friend", mass_emails(:test_transformed).transformed_body(users(:cyrille))
  end

  def test_transformed_body2
    assert_equal "Dear Cyrille,<br/><br/>This email is a test. Your company Bioboy Inc is now on beamazing. Your email is:<br/>cbonnet99@yahoo.fr<br/><br/>", mass_emails(:test_email).transformed_body(users(:cyrille))
  end
  
  def test_transformed_body_password
    cyrille = users(:cyrille)
    old_password_salt = cyrille.salt
    old_crypted_password = cyrille.crypted_password
    assert mass_emails(:test_password).transformed_body(users(:cyrille)).starts_with?("This is your new password:")
    cyrille.reload
    assert old_crypted_password != cyrille.crypted_password
  end
  
  def test_transformed_body_profile
    assert_equal "This is my profile: USER_PROFILE_URL<br/><br/>", mass_emails(:test_transformed_profile).transformed_body(users(:cyrille))
  end
  
end
