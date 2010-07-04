require File.dirname(__FILE__) + '/../test_helper'

class PaymentsControllerTest < ActionController::TestCase
  include ApplicationHelper
  
  def test_thank_you_direct_debit
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    
    get :thank_you_direct_debit, {:id => payments(:pending_user_payment).id}, {:user_id => users(:pending_user).id }
    assert_response :success
    
    assert_equal 1, ActionMailer::Base.deliveries.size
  end
  
  def test_should_get_index
    user = Factory(:user)
    token = Factory(:stored_token, :user => user )
    token_expired = Factory(:stored_token, :user => user, :card_expires_on => 2.days.ago)
    get :index
    assert_redirected_to new_session_url
    get :index, {}, {:user_id => user.id }
    assert_response :success
    assert_not_nil assigns(:payments)
    assert_not_nil assigns(:stored_tokens)
    assert_equal 2, assigns(:stored_tokens).size
    
  end

  def test_should_get_edit
    pending_user = users(:pending_user)
    get :edit, {:id => payments(:pending_user_payment).id}, {:user_id => pending_user.id }
    assert_response :success
    assert_not_nil assigns(:payment)
  end

  def test_pay_new_order
    pending_user = users(:pending_user)
    new_order = Factory(:order, :user_id => pending_user.id, :photo => true, :highlighted => true, :special_offers => 2,
        :gift_vouchers => 1 )
    new_payment = new_order.payment
    expires = Time.now.advance(:year => 1 )
    put :update, {:id => new_payment.id, "payment"=>{"address1"=>"hjgjhghgjhg",
      "city"=>"hjgjhgjhghg",
      "card_number"=>"1",
      "card_expires_on(1i)"=>expires.year.to_s,
      "card_expires_on(2i)"=>expires.month.to_s,
      "card_expires_on(3i)"=>expires.day.to_s,
      "first_name"=>"hjggh",
      "last_name"=>"gjhgjhgjhg",
      "card_verification"=>"123"}}, {:user_id => pending_user.id }
    assert_redirected_to expanded_user_url(pending_user)
    assert_equal "Thank you for your payment. Features are now activated", flash[:notice]
    pending_user.reload
    assert pending_user.active?
    assert pending_user.paid_photo?
    assert_not_nil pending_user.paid_photo_until
    assert_equal (Time.now+1.year).to_date, pending_user.paid_photo_until
    assert pending_user.paid_highlighted?
    assert_not_nil pending_user.paid_highlighted_until
    assert_equal (Time.now+1.year).to_date, pending_user.paid_highlighted_until
    assert_equal 2, pending_user.paid_special_offers
    assert_not_nil pending_user.paid_special_offers_next_date_check
    assert_equal (Time.now+1.year).to_date, pending_user.paid_special_offers_next_date_check
    assert_equal 1, pending_user.paid_gift_vouchers
    assert_not_nil pending_user.paid_gift_vouchers_next_date_check
    assert_equal (Time.now+1.year).to_date, pending_user.paid_gift_vouchers_next_date_check
  end

  def test_pay_new_order_with_renewal
    pending_user = users(:pending_user)
    old_token_count = pending_user.stored_tokens.size
    new_order = Factory(:order, :user_id => pending_user.id, :photo => true, :highlighted => true, :special_offers => 2,
        :gift_vouchers => 1 )
    new_payment = new_order.payment
    expires = Time.now.advance(:year => 1 )
    put :update, {:id => new_payment.id, "payment"=>{"address1"=>"hjgjhghgjhg",
      "city"=>"hjgjhgjhghg",
      "card_number"=>"1",
      "card_expires_on(1i)"=>expires.year.to_s,
      "card_expires_on(2i)"=>expires.month.to_s,
      "card_expires_on(3i)"=>expires.day.to_s,
      "first_name"=>"hjggh",
      "last_name"=>"gjhgjhgjhg",
      "card_verification"=>"123",
      "store_card" => "1"}}, {:user_id => pending_user.id }
    assert_redirected_to expanded_user_url(pending_user)
    assert_equal "Thank you for your payment. Features are now activated", flash[:notice]
    pending_user.reload
    assert_equal old_token_count+1, pending_user.stored_tokens.size
    
    assert pending_user.active?
    assert pending_user.paid_photo?
    assert_not_nil pending_user.paid_photo_until
    assert_equal (Time.now+1.year).to_date, pending_user.paid_photo_until
    assert pending_user.paid_highlighted?
    assert_not_nil pending_user.paid_highlighted_until
    assert_equal (Time.now+1.year).to_date, pending_user.paid_highlighted_until
    assert_equal 2, pending_user.paid_special_offers
    assert_not_nil pending_user.paid_special_offers_next_date_check
    assert_equal (Time.now+1.year).to_date, pending_user.paid_special_offers_next_date_check
    assert_equal 1, pending_user.paid_gift_vouchers
    assert_not_nil pending_user.paid_gift_vouchers_next_date_check
    assert_equal (Time.now+1.year).to_date, pending_user.paid_gift_vouchers_next_date_check
  end

  def test_pay_new_order_with_existing_card
    pending_user = users(:pending_user)
    token = Factory(:stored_token, :user => pending_user)
    new_order = Factory(:order, :user_id => pending_user.id, :photo => true, :highlighted => true, :special_offers => 2,
        :gift_vouchers => 1 )
    new_payment = new_order.payment
    expires = Time.now.advance(:year => 1 )
    put :update, {:id => new_payment.id, "payment"=>{
      "stored_token_id" => token.id}}, {:user_id => pending_user.id }
    assert_redirected_to expanded_user_url(pending_user)
    assert_equal "Thank you for your payment. Features are now activated", flash[:notice]
    pending_user.reload
    
    assert pending_user.active?
    assert pending_user.paid_photo?
    assert_not_nil pending_user.paid_photo_until
    assert_equal (Time.now+1.year).to_date, pending_user.paid_photo_until
    assert pending_user.paid_highlighted?
    assert_not_nil pending_user.paid_highlighted_until
    assert_equal (Time.now+1.year).to_date, pending_user.paid_highlighted_until
    assert_equal 2, pending_user.paid_special_offers
    assert_not_nil pending_user.paid_special_offers_next_date_check
    assert_equal (Time.now+1.year).to_date, pending_user.paid_special_offers_next_date_check
    assert_equal 1, pending_user.paid_gift_vouchers
    assert_not_nil pending_user.paid_gift_vouchers_next_date_check
    assert_equal (Time.now+1.year).to_date, pending_user.paid_gift_vouchers_next_date_check
  end

  def test_pay_new_order_failure
    pending_user = users(:pending_user)
    new_order = Factory(:order, :user_id => pending_user.id, :photo => true, :highlighted => true, :special_offers => 2,
        :gift_vouchers => 1 )
    new_payment = new_order.payment
    expires = Time.now.advance(:year => 1 )
    put :update, {:id => new_payment.id, "payment"=>{"address1"=>"hjgjhghgjhg",
      "city"=>"hjgjhgjhghg",
      "card_number"=>"2",
      "card_expires_on(1i)"=>expires.year.to_s,
      "card_expires_on(2i)"=>expires.month.to_s,
      "card_expires_on(3i)"=>expires.day.to_s,
      "first_name"=>"hjggh",
      "last_name"=>"gjhgjhgjhg",
      "card_verification"=>"123"}}, {:user_id => pending_user.id }
    assert_response :success    
    assert_equal "There was a problem processing your payment. Bogus Gateway: Forced failure", flash[:error]
  end

  def test_pay_extended_order
    pending_user = users(:pending_user)
    expires = Time.now.advance(:year => 1 )
    old_order = Factory(:order, :user_id => pending_user.id, :photo => true, :highlighted => true, :special_offers => 2,
        :gift_vouchers => 1 )
    old_payment = old_order.payment
    put :update, {:id => old_payment.id, "payment"=>{"address1"=>"hjgjhghgjhg",
      "city"=>"hjgjhgjhghg",
      "card_number"=>"1",
      "card_expires_on(1i)"=>expires.year.to_s,
      "card_expires_on(2i)"=>expires.month.to_s,
      "card_expires_on(3i)"=>expires.day.to_s,
      "first_name"=>"hjggh",
      "last_name"=>"gjhgjhgjhg",
      "card_verification"=>"123"}}, {:user_id => pending_user.id }
      assert_redirected_to expanded_user_url(pending_user)

    new_order = Factory(:order, :user_id => pending_user.id, :photo => true, :highlighted => true, :special_offers => 2,
        :gift_vouchers => 1 )
    new_payment = new_order.payment
    put :update, {:id => new_payment.id, "payment"=>{"address1"=>"hjgjhghgjhg",
      "city"=>"hjgjhgjhghg",
      "card_number"=>"1",
      "card_expires_on(1i)"=>expires.year.to_s,
      "card_expires_on(2i)"=>expires.month.to_s,
      "card_expires_on(3i)"=>expires.day.to_s,
      "first_name"=>"hjggh",
      "last_name"=>"gjhgjhgjhg",
      "card_verification"=>"123"}}, {:user_id => pending_user.id }
    assert_redirected_to expanded_user_url(pending_user)
    assert_equal "Thank you for your payment. Features are now activated", flash[:notice]
    pending_user.reload
    assert pending_user.active?
    assert pending_user.paid_photo?
    assert_not_nil pending_user.paid_photo_until
    assert_equal (Time.now+2.years).to_date, pending_user.paid_photo_until
    assert pending_user.paid_highlighted?
    assert_not_nil pending_user.paid_highlighted_until
    assert_equal (Time.now+2.years).to_date, pending_user.paid_highlighted_until
    assert_equal 4, pending_user.paid_special_offers
    assert_not_nil pending_user.paid_special_offers_next_date_check
    assert_equal (Time.now+1.year).to_date, pending_user.paid_special_offers_next_date_check
    assert_equal 2, pending_user.paid_gift_vouchers
    assert_not_nil pending_user.paid_gift_vouchers_next_date_check
    assert_equal (Time.now+1.year).to_date, pending_user.paid_gift_vouchers_next_date_check
  end

  # def test_edit_payment_on_full_membership_upgrade
  #   rmoore = users(:rmoore)
  #   new_payment = rmoore.payments.create!(Payment::TYPES[:renew_full_member])
  #   get :edit, {:id => new_payment.id}, {:user_id => rmoore.id }
  #   assert_response :success
  #   assert_not_nil assigns(:payment)
  #   assert_equal 19900, assigns(:payment).amount
  # end
  # 
  # def test_update_payment_on_full_membership_upgrade
  #   rmoore = users(:rmoore)
  #   heart_children = charities(:heart_children)
  #   new_payment = rmoore.payments.create!(Payment::TYPES[:full_member])
  #   
  #   expires = Time.now.advance(:year => 1 )
  #   put :update, {:id => new_payment.id, "payment"=>{:charity_id => heart_children.id, "address1"=>"hjgjhghgjhg",
  #     "city"=>"hjgjhgjhghg",
  #     "card_number"=>"1",
  #     "card_expires_on(1i)"=>expires.year.to_s,
  #     "card_expires_on(2i)"=>expires.month.to_s,
  #     "card_expires_on(3i)"=>expires.day.to_s,
  #     "first_name"=>"hjggh",
  #     "last_name"=>"gjhgjhgjhg",
  #     "card_verification"=>"123"}}, {:user_id => rmoore.id }
  #   assert_response :success
  #   assert_template "thank_you"
  #   rmoore.reload
  #   assert rmoore.active?
  #   assert_not_nil rmoore.member_since
  #   assert !rmoore.free_listing?
  #   assert rmoore.full_member?
  #   new_payment.reload
  #   assert new_payment.completed?
  #   assert_equal heart_children.id, new_payment.charity_id
  # end

end
