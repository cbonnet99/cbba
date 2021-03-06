require 'test/unit'
require 'rubygems'
require 'mocha'
require File.dirname(__FILE__) + '/test_helper.rb'
#include UserEventLogger::UserEventLoggerViewHelper

class ViewHelpersTest < Test::Unit::TestCase
  def setup
    @view = ActionView::Base.new
    r = mock('request')
    r.stubs(:path).returns("the path")
    r.stubs(:remote_ip).returns("the remote IP")
    @view.stubs(:request).returns(r)
  end
  
  def get_last_event
    UserEvent.find(:first, :order => "id DESC")
  end
  
  def test_log_user_event
    @view.log_user_event "the name", "the destination URL", "the extra data"
    e = get_last_event
    assert_equal "the path", e.source_url
    assert_equal "the destination URL", e.destination_url
    assert_equal "the name", e.event_type
    assert_equal "the remote IP", e.remote_ip
    assert_equal "the extra data", e.extra_data
    assert_equal "the name", e.event_type
  end

  def test_log_user_event_with_defaults
    @view.log_user_event "the name"
    e = get_last_event
    assert_equal "the path", e.source_url
    assert_equal nil, e.destination_url
    assert_equal "the name", e.event_type
    assert_equal "the remote IP", e.remote_ip
    assert_equal nil, e.extra_data
    assert_equal "the name", e.event_type
  end
  
  def test_log_user_event_with_extra_option
    @view.log_user_event "the name", "the destination URL", "the extra data", {:extra_option => "the extra option"}
    e = get_last_event
    assert_equal "the path", e.source_url
    assert_equal "the destination URL", e.destination_url
    assert_equal "the name", e.event_type
    assert_equal "the remote IP", e.remote_ip
    assert_equal "the extra data", e.extra_data
    assert_equal "the name", e.event_type
    assert_equal "the extra option", e.extra_option
  end

end