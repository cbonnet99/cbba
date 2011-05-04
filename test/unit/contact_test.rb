require File.dirname(__FILE__) + '/../test_helper'

class ContactTest < ActiveSupport::TestCase
  fixtures :all

  def test_authenticate
    joe = contacts(:joe)
    assert_not_nil Contact.authenticate(joe.email, "monkey")
    assert_nil Contact.authenticate(joe.email, "blabla")
  end
  
  def test_create
    nz = countries(:nz)
    new_contact = Contact.create(:email => "test@test.com", :country => nz)
    assert new_contact.errors.blank?, "Contacts should be able to create an account very quickly with minimal information: just their email address and a country"
    assert !new_contact.crypted_password.blank?, "Contacts should be assigned a password automatically if they didn't provide one"
    assert new_contact.unconfirmed?
    assert_equal "unconfirmed", new_contact.state
  end
  
  def test_authenticate
    joe = contacts(:joe)
    assert_equal joe, Contact.authenticate(joe.email, "monkey")
  end
  
  def test_unique
    double = Contact.new(:email => contacts(:joe).email )
    assert !double.valid?
  end
  def test_unique_users
    double = Contact.new(:email => users(:cyrille).email )
    assert !double.valid?
  end
end
