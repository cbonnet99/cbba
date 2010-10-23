require File.dirname(__FILE__) + '/../test_helper'

class PaymentTest < ActiveSupport::TestCase
  fixtures :all
  include ApplicationHelper

  def test_purchase
    payment = users(:cyrille).payments.create(:amount => 3000 )
    payment.purchase!
  end

  #for GST calculations, see http://www.ird.govt.nz/technical-tax/general-articles/qwba-gst-5cent-coin-rounding.html
  #IMPORTANT: the numbers quoted in the article above are INCLUSIVE of GST
  def test_compute_gst
    payment = users(:cyrille).payments.create(:amount => 2302 )
    assert_equal 345, payment.gst
  end

  def test_compute_gst2
    payment = users(:cyrille).payments.create(:amount => 2293 )
    assert_equal 344, payment.gst
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
    
    #testing that the publication info is reset...
    pending_user.user_profile.published_at = Time.now
    pending_user.user_profile.approved_at = Time.now
    pending_user.user_profile.approved_by_id = users(:cyrille).id
    pending_user.user_profile.save!
    
    payment = pending_user.payments.create!(Payment::TYPES[:full_member])
    payment.update_attributes(:card_number => "1", :card_expires_on => Time.now)
    payment.purchase!
    pending_user.reload
    assert_equal Time.zone.now.to_date, pending_user.member_since.to_date
    assert_equal 1.year.from_now.to_date, pending_user.member_until.to_date
    #an email should have been sent
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_nil pending_user.user_profile.published_at, "Publication info should have been reset"
    assert_nil pending_user.user_profile.approved_at, "Publication info should have been reset"
    assert_nil pending_user.user_profile.approved_by_id, "Publication info should have been reset"
  end

end
