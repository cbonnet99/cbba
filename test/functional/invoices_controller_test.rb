require File.dirname(__FILE__) + '/../test_helper'

class InvoicesControllerTest < ActionController::TestCase
  fixtures :all
  
  def test_show
    get :show, {:id => invoices(:invoice_for_completed) }, {:user_id => users(:rmoore).id }
    assert_response :success
    assert_equal "You cannot access this invoice", flash[:error]
  end
  
  def test_show2
    get :show, {:id => invoices(:invoice_for_completed) }, {:user_id => users(:cyrille).id }
    assert_response :success
    assert_not_equal "You cannot access this invoice", flash[:error]
  end
end
