require File.dirname(__FILE__) + '/../test_helper'

class SessionsControllerTest < ActionController::TestCase
	fixtures :all

  include ApplicationHelper

  def test_create_admin
    cyrille = users(:cyrille)
    post :create, :email => cyrille.email, :password => "monkey"
    assert_redirected_to reviewer_url(:action => "index" )
    assert_equal "Logged in successfully", flash[:notice]
    cyrille.reload
    assert !cyrille.free_listing?
  end
  def test_create_admin_with_capitals
    cyrille = users(:cyrille)
    post :create, :email => cyrille.email.upcase, :password => "monkey"
    assert_redirected_to reviewer_url(:action => "index" )
    assert_equal "Logged in successfully", flash[:notice]
    cyrille.reload
    assert !cyrille.free_listing?
  end
  def test_create
    norma = users(:norma)
    start_call = Time.now
    post :create, :email => norma.email, :password => "monkey"
    end_call = Time.now
    assert_redirected_to user_home_url
    assert_equal "Logged in successfully", flash[:notice]
    norma.reload
    assert !norma.free_listing?
    assert_not_nil norma.last_logged_at
    assert start_call <= norma.last_logged_at
    assert norma.last_logged_at <= end_call
  end
  def test_create_free_listing
    rmoore = users(:rmoore)
    post :create, :email => rmoore.email, :password => "monkey"
    assert_redirected_to user_edit_url
    assert_equal "Logged in successfully", flash[:notice]
    rmoore.reload
    assert rmoore.free_listing?
  end
  def test_create_pending
    pending_user = users(:pending_user)
    pending_user_payment = payments(:pending_user_payment)
    post :create, :email => pending_user.email, :password => "monkey"
    assert_not_nil assigns(:payment)
    assert_equal pending_user_payment, assigns(:payment)
    assert_redirected_to edit_payment_url(assigns(:payment))
    assert_equal "You need to complete your payment", flash[:warning]
  end
  def test_create_pending_without_payment
    suspended_user2 = users(:suspended_user2)
    post :create, :email => suspended_user2.email, :password => "monkey"
    assert_not_nil assigns(:payment)
    assert_redirected_to edit_payment_url(assigns(:payment))
    assert_equal "You need to complete your payment", flash[:warning]
  end
end