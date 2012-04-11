require File.dirname(__FILE__) + '/../test_helper'

class PaymentTest < ActiveSupport::TestCase
  fixtures :all
  include ApplicationHelper

  #for GST calculations, see http://www.ird.govt.nz/technical-tax/general-articles/qwba-gst-5cent-coin-rounding.html
  #IMPORTANT: the numbers quoted in the article above are INCLUSIVE of GST

  def test_no_gst
    au = countries(:au)
    au_user = Factory(:user, :country => au)
    payment = Factory(:payment, :user => au_user)
    
    assert_equal 0, payment.gst
    assert_equal "AUD", payment.purchase_options[:currency]
  end

  def test_compute_gst
    payment = users(:cyrille).payments.create(:amount => 2580 )
    assert_equal 387, payment.gst
  end

  def test_compute_gst2
    payment = users(:cyrille).payments.create(:amount => 2590 )
    assert_equal 388, payment.gst
  end

  def test_compute_gst3
    payment = users(:cyrille).payments.create(:amount => 2298 )
    assert_equal 345, payment.gst
  end

  def test_compute_gst4
    payment = users(:cyrille).payments.create(:amount => 19900 )
    assert_equal 2985, payment.gst
  end

  def test_compute_new_gst
    payment = users(:cyrille).payments.create(:amount => 19900 )
    assert_equal 2985, payment.gst
    payment.update_attributes(:amount => 1000, :first_name => "Joe", :last_name => "Card",  :card_type => "Visa",
     :card_number => "4111111111111111", :card_verification => "111", :card_expires_on => 1.year.from_now)
    payment.reload
    assert payment.valid?, "Errors on payment: #{payment.errors.full_messages.to_sentence}"
    assert_equal 1000, payment.amount
    assert_equal 150, payment.gst
  end

  def test_amount_view
    assert_equal "AUD$101.45", amount_view(10145, "AUD")
  end

  def test_pending
    pending_user = Factory(:user)
    pending_payment = Factory(:payment, :status => "pending", :user => pending_user)
    
    assert_equal 1, pending_user.payments.pending.size
  end
  
  def test_mark_as_paid
    
    pending_user = Factory(:user)
    order = pending_user.orders.create(:photo => true, :highlighted  => true, :special_offers => 2,
      :gift_vouchers => 2)
    payment = order.create_payment
    
    payment.mark_as_paid!
    
    payment.reload
    assert_not_nil payment.paid_at

    order.reload
    assert_not_nil order.paid_at
  
  end
  
  def test_purchase
    pending_user = Factory(:user)
    ActionMailer::Base.deliveries = []
    
    #testing that the publication info is reset...
    pending_user.user_profile.published_at = Time.now
    pending_user.user_profile.approved_at = Time.now
    pending_user.user_profile.approved_by_id = users(:cyrille).id
    pending_user.user_profile.save!
    
    assert_equal Time.zone.now.to_date, pending_user.member_since.to_date
    assert_equal 1.year.from_now.to_date, pending_user.member_until.to_date
  end

end
