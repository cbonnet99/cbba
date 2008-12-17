require File.dirname(__FILE__) + '/../test_helper'

class ContactsControllerTest < ActionController::TestCase
  fixtures :all

  test "creation errors" do
    post :create, {}
    assert_not_nil assigns(:contact)
    assert assigns(:contact).errors.size > 0
  end
  test "creation success" do
    post :create, {:contact => {:email => "cyrille@blob.com" }}
    assert_not_nil assigns(:contact)
#    puts assigns(:contact).errors.inspect
    assert_equal 0, assigns(:contact).errors.size
  end
end
