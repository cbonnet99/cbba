require File.dirname(__FILE__) + '/../test_helper'

class GetContactsTest < Test::Unit::TestCase
  include TestHelper
  
  def setup
    @gateway = XeroGateway::Gateway.new(
      :customer_key => CUSTOMER_KEY,
      :api_key => API_KEY    
    )
    
    if STUB_XERO_CALLS
      @gateway.xero_url = "DUMMY_URL"
      
      @gateway.stubs(:http_get).with {|url, params| url =~ /contacts$/ }.returns(get_file_as_string("contacts.xml"))          
      @gateway.stubs(:http_put).with {|url, body, params| url =~ /contact$/ }.returns(get_file_as_string("contact.xml"))          
    end
  end
  
  def test_get_contacts
    # Make sure there is an contact in Xero to retrieve
    contact = @gateway.create_contact(dummy_contact).contact
    flunk "get_contacts could not be tested because create_contact failed" if contact.nil?

    result = @gateway.get_contacts
    assert result.success?
    assert !result.request_params.nil?
    assert !result.response_xml.nil?
    assert result.contacts.collect {|c| c.contact_id}.include?(contact.contact_id)
  end  
end