require File.dirname(__FILE__) + '/../test_helper'

class NewsletterTest < ActiveSupport::TestCase
  
  def test_generate_body
    n = Factory(:newsletter)
    n.generate_body
    # assert !n.body.blank?
  end
  
end
