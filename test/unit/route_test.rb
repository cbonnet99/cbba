require File.dirname(__FILE__) + '/../test_helper'

class RoutingTest < Test::Unit::TestCase
  def test_routes
    assert_recognizes({:controller => 'users', :action => 'publish', :id => "221", }, :path => "/user_profiles/221/publish")
    assert_recognizes({:controller => 'search', :action => 'test'}, :path => "/search/test")
    assert_recognizes({:controller => 'tabs', :action => 'edit', :user_id => "cyrille-bonnet", :id => "tab-2" }, :path => "/users/cyrille-bonnet/tabs/tab-2/edit")
    assert_recognizes({:controller => 'users', :action => 'show', :id => "user-slug", :selected_tab_id => "tab-slug" }, :path => "/users/user-slug/tab-slug")
    assert_recognizes({:controller => 'tabs', :action => 'show', :id => "tab-slug", :user_id => "user-slug" }, :path => "/users/user-slug/tabs/tab-slug/show")
    assert_recognizes({:controller => 'tabs', :action => 'destroy', :id => "tab-slug", :user_id => "user-slug" }, :path => "/users/user-slug/tabs/tab-slug/destroy")
    assert_recognizes({:controller => 'tabs', :action => 'create', :format => "js"}, :path => "/tabs/create.js")
    assert_recognizes({:controller => 'tabs', :action => 'create'}, :path => "/tabs/create")
    assert_recognizes({:controller => 'articles', :action => 'publish', :id => "123"  }, {:path => "/articles/123/publish", :method => :post })
    assert_recognizes({:controller => 'users', :action => 'update', :id => "123"   }, {:path => "/users/123", :method => :put })
    assert_recognizes({:controller => 'users', :action => 'create'  }, {:path => "/users", :method => :post })
    assert_recognizes({:controller => 'search', :action => 'search'  }, "/search")
    assert_recognizes({:controller => 'regions', :action => 'districts', :format => "js", :id => "0"  }, "/regions/0.js/districts")
    assert_recognizes({:controller => 'users', :action => 'edit'  }, "/users/edit")
	end
end