require File.dirname(__FILE__) + '/../test_helper'

class MessagesControllerTest < ActionController::TestCase
  fixtures :all

  def test_create
    cyrille = users(:cyrille)
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    post :create, :message => {:preferred_contact => "021 185 3433", :subject => "I like your style", :body => "When can I get an appointment?", :user_id => cyrille.id}
    assert_redirected_to root_url

    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_equal [cyrille.email], ActionMailer::Base.deliveries.first.to
  end
end
