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
  
  def test_create_for_unpublished_user
    unpublished_user = Factory(:user, :password => "foobar")
    unpublished_profile = Factory(:user_profile, :user => unpublished_user, :state => "draft")

    post :create, :email => unpublished_user.email, :password => "foobar"

    assert_equal "Logged in successfully", flash[:notice]
    assert_redirected_to expanded_user_url(unpublished_user)

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
end