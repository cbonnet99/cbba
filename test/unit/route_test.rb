require File.dirname(__FILE__) + '/../test_helper'

class RoutingTest < Test::Unit::TestCase
  def test_regions
    assert_recognizes({:controller => 'articles', :action => 'publish', :id => "123"  }, {:path => "/articles/123/publish", :method => :post })
    assert_recognizes({:controller => 'users', :action => 'create'  }, {:path => "/users", :method => :post })
    assert_recognizes({:controller => 'search', :action => 'search'  }, "/search")
    assert_recognizes({:controller => 'regions', :action => 'districts', :format => "js", :id => "0"  }, "/regions/0.js/districts")
    assert_recognizes({:controller => 'users', :action => 'edit'  }, "/users/edit")
	end
end