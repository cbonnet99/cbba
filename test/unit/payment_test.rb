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
    assert_equal "AUD", payment.purchase_options[:input_currency]
    assert_equal "AU", payment.purchase_options[:billing_address][:country], "Purchase options are: #{payment.purchase_options.inspect}"
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

  def test_amount_view
    assert_equal "AUD$101.45", amount_view(10145, "AUD")
  end

  def test_pending
    pending_user = Factory(:user)
    pending_payment = Factory(:payment, :status => "pending", :user => pending_user)
    
    assert_equal 1, pending_user.payments.pending.size
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
