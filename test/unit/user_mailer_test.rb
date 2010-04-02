require File.dirname(__FILE__) + '/../test_helper'

class UserMailerTest < ActionMailer::TestCase
  tests UserMailer

  fixtures :all

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
    actual_mail = UserMailer.create_notify_unpublished(users(:norma), 7.days.ago)
    assert_match %r{unsubscribe_token}, actual_mail.body
  end
  
end
