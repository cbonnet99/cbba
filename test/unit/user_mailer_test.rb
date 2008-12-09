require File.dirname(__FILE__) + '/../test_helper'

class UserMailerTest < ActionMailer::TestCase
  tests UserMailer

  fixtures :all

  def test_stuff_to_review
    cyrille = users(:cyrille)

    actual_mail = UserMailer.create_stuff_to_review(cyrille.user_profile, cyrille)

    @expected.subject = '[Be Amazing(development)] Review needed'
    @expected.body    = read_fixture('stuff_to_review')

    @expected.from = APP_CONFIG[:admin_email]
    @expected.to = cyrille.email
    @expected.date    = actual_mail.date

    assert_equal @expected.encoded, actual_mail.encoded

  end
end
