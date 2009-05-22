require File.dirname(__FILE__) + '/../test_helper'

class GiftVouchersControllerTest < ActionController::TestCase
  fixtures :all
  
  def test_index_public
    get :index_public
  end
end
