require File.dirname(__FILE__) + '/../test_helper'

class PaymentsControllerTest < ActionController::TestCase
  def test_should_get_index
    cyrille = users(:cyrille)
    get :index
    assert_redirected_to new_session_path
    get :index, {}, {:user_id => cyrille.id }
    assert_response :success
    assert_not_nil assigns(:payments)
  end

  def test_should_get_edit
    cyrille = users(:cyrille)
    get :edit, {:id => payments(:pending).id}, {:user_id => cyrille.id }
    assert_response :success
  end

  def test_should_update_payment
    pending_user = users(:pending_user)
    new_payment = pending_user.payments.create!(:type => Payment::TYPES[:full_member], :title => Payment::TYPES[:full_member][:title],
      :amount => Payment::TYPES[:full_member][:amount])
    put :update, {:id => new_payment.id, "payment"=>{"address1"=>"hjgjhghgjhg",
      "city"=>"hjgjhgjhghg",
      "card_number"=>"1",
      "card_expires_on(1i)"=>"2009",
      "card_expires_on(2i)"=>"4",
      "card_expires_on(3i)"=>"1",
      "first_name"=>"hjggh",
      "last_name"=>"gjhgjhgjhg",
      "card_verification"=>"123"}}, {:user_id => pending_user.id }
    assert_response :success
    assert_template "thank_you"
    pending_user.reload
    assert pending_user.active?
  end

end
