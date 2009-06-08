require File.dirname(__FILE__) + '/../test_helper'

class MessagesControllerTest < ActionController::TestCase
  fixtures :all

  def test_create
    cyrille = users(:cyrille)
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    old_events_size = UserEvent.all.size
    post :create, :message => {:preferred_contact => "021 185 3433", :subject => "I like your style", :body => "When can I get an appointment?", :user_id => cyrille.id}
    assert_redirected_to root_url

    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_equal [cyrille.email], ActionMailer::Base.deliveries.first.to
    
    #1 event to verify captcha and 1 event for the msg
    assert_equal old_events_size+2, UserEvent.all.size
    last_event = UserEvent.find(:first, :order => "logged_at desc")
    assert_equal cyrille.id, last_event.visited_user_id
    assert_equal UserEvent::MSG_SENT, last_event.event_type
  end
end
