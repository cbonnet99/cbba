require File.dirname(__FILE__) + '/../test_helper'

class FriendMessageTest < ActiveSupport::TestCase
  def test_invalid_messages
    fm = FriendMessage.new()
    assert !fm.valid?
    fm = FriendMessage.new(:to_email => "dsdgfgfdgfdg" )
    assert !fm.valid?
    fm = FriendMessage.new(:to_email => "dsdgfg@test.com" )
    assert !fm.valid?
    fm = FriendMessage.new(:to_email => "dsdgfg@test.com", :subject => "An article"  )
    assert !fm.valid?
    fm = FriendMessage.new(:to_email => "dsdgfg@test.com", :subject => "An article", :body => "Here it is")
    assert !fm.valid?
    fm = FriendMessage.new(:from_email  => "dfsfdsf", :to_email => "dsdgfg@test.com", :subject => "An article", :body => "Here it is")
    assert !fm.valid?
    fm = FriendMessage.new(:from_email  => "dfsfdsf@test.com", :to_email => "dsdgfg@test.com", :subject => "An article", :body => "Here it is")
    assert fm.valid?
    fm = FriendMessage.new(:to_email => "dsdgfg@test.com", :subject => "An article", :body => "Here it is")
    fm.from_user_id = users(:cyrille).id
    assert fm.valid?, "Errors were: #{fm.errors.full_messages.to_sentence}"
  end
end
