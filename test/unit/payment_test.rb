require File.dirname(__FILE__) + '/../test_helper'

class PaymentTest < ActiveSupport::TestCase
  fixtures :all
  include ApplicationHelper


  #for GST calculations, see http://www.ird.govt.nz/technical-tax/general-articles/qwba-gst-5cent-coin-rounding.html
  #IMPORTANT: the numbers quoted in the article above are INCLUSIVE of GST
  def test_compute_gst
    payment = Payment.create(:amount => 2302 )
    assert_equal 288, payment.gst
  end

  def test_compute_gst2
    payment = Payment.create(:amount => 2293 )
    assert_equal 287, payment.gst
  end

  def test_amount_view
    assert_equal "$101.45", amount_view(10145)
  end

  def test_pending
    pending_user = users(:pending_user)
    assert_equal 1, pending_user.payments.pending.size
  end

  def test_renewals
    cyrille = users(:cyrille)
    old_size = cyrille.payments.renewals.size
    payment = cyrille.payments.create!(Payment::TYPES[:renew_full_member])
    assert_equal 0, payment.errors.size
    cyrille.reload
    assert_equal old_size+1, cyrille.payments.renewals.size
  end

  def test_purchase
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    pending_user = users(:pending_user)
    payment = pending_user.payments.create!(Payment::TYPES[:full_member])
    payment.update_attributes(:card_number => "1", :card_expires_on => Time.now)
    payment.purchase
    pending_user.reload
    assert_equal Time.now.to_date, pending_user.member_since.to_date
    assert_equal 1.year.from_now.to_date, pending_user.member_until.to_date
    #an email should have been sent
    assert_equal 1, ActionMailer::Base.deliveries.size
  end

  def test_purchase_renew
    cyrille = users(:cyrille)
    old_member_since = cyrille.member_since
    old_member_until = cyrille.member_until
    payment = cyrille.payments.create!(Payment::TYPES[:renew_full_member])
    payment.update_attributes(:card_number => "1", :card_expires_on => Time.now)
    payment.purchase
    cyrille.reload
    assert_equal old_member_since, cyrille.member_since
    assert_equal old_member_until+1.year, cyrille.member_until
  end

end
