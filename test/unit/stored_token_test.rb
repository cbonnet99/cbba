require File.dirname(__FILE__) + '/../test_helper'

class StoredTokenTest < ActiveSupport::TestCase
  def test_card_expired
    token = Factory(:stored_token)
    assert !token.card_expired?
    token_expired = Factory(:stored_token, :card_expires_on => 2.days.ago)
    assert token_expired.card_expired?    
  end
end
