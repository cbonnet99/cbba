require File.dirname(__FILE__) + '/../test_helper'

class PaymentTest < ActiveSupport::TestCase
  fixtures :all
  include ApplicationHelper

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
    cyrille.reload
    assert_equal old_size+1, cyrille.payments.renewals.size
  end

  def test_purchase
    pending_user = users(:pending_user)
    payment = pending_user.payments.create!(Payment::TYPES[:full_member])
    payment.update_attributes(:card_number => "1", :card_expires_on => Time.now)
    payment.purchase
    pending_user.reload
    assert_equal Time.now.to_date, pending_user.member_since.to_date
    assert_equal 1.year.from_now.to_date, pending_user.member_until.to_date
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
