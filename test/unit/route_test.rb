require File.dirname(__FILE__) + '/../test_helper'

class RoutingTest < Test::Unit::TestCase
  def test_regions
    assert_recognizes({:controller => 'regions', :action => 'districts', :format => "js", :id => "0"  }, "/regions/0.js/districts")
	end
end