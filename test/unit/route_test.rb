require File.dirname(__FILE__) + '/../test_helper'

class RoutingTest < Test::Unit::TestCase
  def test_regions
    assert_recognizes({:controller => 'search', :action => 'search'  }, "/search")
    assert_recognizes({:controller => 'regions', :action => 'districts', :format => "js", :id => "0"  }, "/regions/0.js/districts")
    assert_recognizes({:controller => 'users', :action => 'edit'  }, "/users/edit")
	end
end