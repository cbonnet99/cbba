require File.dirname(__FILE__) + '/../test_helper'

class UserMailerTest < ActionMailer::TestCase
  tests UserMailer

  fixtures :all
  
  def test_free_tool
    contact = Factory(:contact)
    
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    
    UserMailer.deliver_free_tool(contact)
    
    assert_equal 1, ActionMailer::Base.deliveries.size
    invoice_email = ActionMailer::Base.deliveries.first
    assert_match /thanks for joining/, invoice_email.body
  end
  
  def test_payment_invoice_nz
    nz = countries(:nz)
    user = Factory(:user, :country => nz)
    payment = Factory(:payment, :user => user)
    invoice = Factory(:invoice, :payment => payment)

    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    
    UserMailer.deliver_payment_invoice(user, payment, invoice)

    assert_equal 1, ActionMailer::Base.deliveries.size
    invoice_email = ActionMailer::Base.deliveries.first
    assert_match /GST/, invoice_email.body
  end
  
  def test_payment_invoice_au
    au = countries(:au)
    user = Factory(:user, :country => au)
    payment = Factory(:payment, :user => user)
    invoice = Factory(:invoice, :payment => payment)

    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    
    UserMailer.deliver_payment_invoice(user, payment, invoice)

    assert_equal 1, ActionMailer::Base.deliveries.size
    invoice_email = ActionMailer::Base.deliveries.first
    assert_no_match /GST/, invoice_email.body
  end
  
  def test_news_digest

    contact = Factory(:contact)
    
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    news_digest = NewsDigest.create_new
    UserMailer.deliver_news_digest(contact, news_digest)
    
    assert_equal 1, ActionMailer::Base.deliveries.size
    digest_email = ActionMailer::Base.deliveries.first
    assert_match /Digest/, digest_email.subject
    assert_match /Articles/, digest_email.body
  end

  def test_weekly_admin_statistics
    cyrille = users(:cyrille)
    UserMailer.deliver_weekly_admin_statistics(cyrille)
  end

  def test_stuff_to_review
    cyrille = users(:cyrille)

    actual_mail = UserMailer.create_stuff_to_review(cyrille.user_profile, cyrille)

    @expected.subject = '[Be Amazing(test)] Review needed'
    @expected.body    = read_fixture('stuff_to_review')

    @expected.from = APP_CONFIG[:admin_email]
    @expected.to = cyrille.email
    @expected.date    = actual_mail.date

    assert_equal @expected.encoded, actual_mail.encoded

  end
  def test_coming_membership_expiration
    cyrille = users(:cyrille)

    actual_mail = UserMailer.create_coming_membership_expiration(cyrille, "2 weeks")

  end
  
  def test_mass_email_newsletter_user
    cyrille = users(:cyrille)
    actual_mail = UserMailer.create_mass_email_newsletter(cyrille, "Test", newsletters(:may_published))
  end
  
  def test_mass_email_newsletter_contact
    joe = contacts(:joe)
    actual_mail = UserMailer.create_mass_email_newsletter(joe, "Test", newsletters(:may_published))
  end

  def test_notify_unpublished
    actual_mail = UserMailer.create_notify_unpublished(users(:norma))
  end
  
end
