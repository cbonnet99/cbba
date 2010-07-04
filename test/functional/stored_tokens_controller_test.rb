require File.dirname(__FILE__) + '/../test_helper'

class StoredTokensControllerTest < ActionController::TestCase

  def test_delete
    user = Factory(:user)
    token = Factory(:stored_token, :user => user )
    old_count = user.stored_tokens.size
    post :destroy, {:id => token.id }
    assert_redirected_to new_session_url
    get :destroy, {:id => token.id }, {:user_id => user.id }
    assert_redirected_to payments_url
    assert_equal old_count-1, user.stored_tokens.size    
  end
  def test_edit
    user = Factory(:user)
    token = Factory(:stored_token, :user => user )
    get :edit, {:id => token.id }
    assert_redirected_to new_session_url
    get :edit, {:id => token.id }, {:user_id => user.id }
    assert_response :success
    assert_not_nil assigns(:token)
  end
  def test_new
    user = Factory(:user)
    get :new
    assert_redirected_to new_session_url
    get :new, {}, {:user_id => user.id }
    assert_response :success
    assert_not_nil assigns(:token)    
  end
  def test_create
    user = Factory(:user)
    old_count = user.stored_tokens.size
    expires = 1.year.from_now
    post :create, {:stored_token => {:first_name => "Tom", :last_name => "Jones", :card_number => "1", "card_expires_on(1i)"=>expires.year.to_s,
    "card_expires_on(2i)"=>expires.month.to_s,
    "card_expires_on(3i)"=>expires.day.to_s,
    } }, {:user_id => user.id }
    assert_not_nil assigns(:token)
    assert !assigns(:token).last4digits
    assert assigns(:token).errors.blank?, "Errors: #{assigns(:token).errors.full_messages.to_sentence}"
    assert_redirected_to payments_url
    assert_nil flash[:error], "Flash was: #{flash.inspect}"
    assert_not_nil flash[:notice], "Flash was: #{flash.inspect}"
    user.reload
    assert_equal old_count+1, user.stored_tokens.size
  end
end
