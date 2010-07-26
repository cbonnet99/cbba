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
      
      old_size = Contact.all.size
      post :create, {:contact => {:email => "cyrille@blob.com" }}
      assert_equal old_size, Contact.all.size
    end

    test "creation for member" do
      cyrille = users(:cyrille)
      cyrille.receive_newsletter = false
      cyrille.save!
      cyrille.reload
      post :create, {:contact => {:email => cyrille.email }}
      assert_not_nil assigns(:contact)
      assert assigns(:contact).errors.blank?
  
      cyrille.reload
      assert cyrille.receive_newsletter
    end

  def test_unsubscribe
    joe = contacts(:joe)
    assert joe.receive_newsletter?
    get :unsubscribe, :token => joe.unsubscribe_token, :id => joe.id
    assert_response :success
    assert_template 'unsubscribe_success'
    joe.reload
    assert !joe.receive_newsletter?
  end
  
  def test_unsubscribe_failure
    joe = contacts(:joe)
    assert joe.receive_newsletter?
    get :unsubscribe, :token => "bla", :id => joe.id
    assert_response :success
    assert_template 'unsubscribe_failure'
    joe.reload
    assert joe.receive_newsletter?
  end
  
end
