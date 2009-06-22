require File.dirname(__FILE__) + '/../test_helper'

class PaymentTest < ActiveSupport::TestCase
  fixtures :all
  include ApplicationHelper

  #for GST calculations, see http://www.ird.govt.nz/technical-tax/general-articles/qwba-gst-5cent-coin-rounding.html
  #IMPORTANT: the numbers quoted in the article above are INCLUSIVE of GST
  def test_compute_gst
    payment = users(:cyrille).payments.create(:amount => 2302 )
    assert_equal 288, payment.gst
  end

  def test_compute_gst2
    payment = users(:cyrille).payments.create(:amount => 2293 )
    assert_equal 287, payment.gst
  end

  def test_compute_gst3
    payment = users(:cyrille).payments.create(:amount => 2298 )
    assert_equal 287, payment.gst
  end

  def test_compute_gst4
    payment = users(:cyrille).payments.create(:amount => 19900 )
    assert_equal 2487, payment.gst
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

  def test_purchase_resident_expert
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    applying_resident_expert = users(:applying_resident_expert)
    applying_expert = expert_applications(:applying_expert)
    payment = applying_resident_expert.payments.create!(Payment::TYPES[:resident_expert])
    payment.update_attributes(:card_number => "1", :card_expires_on => Time.now, :expert_application => applying_expert )
    payment.purchase
    applying_resident_expert.reload
    assert_equal Time.now.to_date, applying_resident_expert.resident_since.to_date
    assert_equal 1.year.from_now.to_date, applying_resident_expert.resident_until.to_date
    #make sure that member dates are aligned
    assert_equal Time.now.to_date, applying_resident_expert.member_since.to_date
    assert_equal 1.year.from_now.to_date, applying_resident_expert.member_until.to_date
    #an email should have been sent
    assert_equal 1, ActionMailer::Base.deliveries.size
    applying_resident_expert.reload
    assert applying_resident_expert.resident_expert?
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
    old_resident_since = cyrille.resident_since
    old_resident_until = cyrille.resident_until
    payment = cyrille.payments.create!(Payment::TYPES[:renew_resident_expert])
    payment.update_attributes(:card_number => "1", :card_expires_on => Time.now)
    payment.purchase
    cyrille.reload
    assert_equal old_resident_since, cyrille.resident_since
    assert_equal old_resident_until+1.year, cyrille.resident_until
  end

end
