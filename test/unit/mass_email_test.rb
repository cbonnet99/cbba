require File.dirname(__FILE__) + '/../test_helper'

class MassEmailTest < ActiveSupport::TestCase
  fixtures :all

  def test_transformed_body
    assert_equal "This is 10% my friend", mass_emails(:test_transformed).transformed_body(users(:cyrille))
  end

  def test_transformed_body2
    assert_equal "Dear Cyrille,\n\nThis email is a test. Your company Bioboy Inc is now on beamazing. Your email is:\ncbonnet99@gmail.com\n\n", mass_emails(:test_email).transformed_body(users(:cyrille))
  end
end
