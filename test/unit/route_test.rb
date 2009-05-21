require File.dirname(__FILE__) + '/../test_helper'

class RoutingTest < Test::Unit::TestCase
  def test_routes
    assert_recognizes({:controller => 'users', :action => "stats"  }, :path => "/users/stats" )
    assert_recognizes({:controller => 'search', :action => "whyjoin"  }, :path => "/whyjoin" )
    assert_recognizes({:controller => 'search', :action => "team"  }, :path => "/team" )
    assert_recognizes({:controller => 'search', :action => "goals"  }, :path => "/goals" )
    assert_recognizes({:controller => 'search', :action => "about"  }, :path => "/about" )
    assert_recognizes({:controller => 'special_offers', :action => "index_public"  }, :path => "/special_offers/index_public" )
    assert_recognizes({:controller => 'gift_vouchers', :action => "index_public"  }, :path => "/gift_vouchers/index_public" )
    assert_recognizes({:controller => 'admin/payments', :action => "mark_as_paid", :id => "123"  }, :path => "/admin/payments/123/mark_as_paid" )
    assert_recognizes({:controller => 'payments', :action => "edit_debit", :id => "123"  }, :path => "/payments/123/edit_debit" )
    assert_recognizes({:controller => 'search', :action => "search", :where => "wellington" }, :path => "/search/where/wellington" )
    assert_recognizes({:controller => 'search', :action => "search",  :what => 'yoga' }, :path => "/search/what/yoga" )
    assert_recognizes({:controller => 'search', :action => "search",  :what => 'yoga', :where => "wellington" }, :path => "/search/what/yoga/where/wellington" )
    assert_recognizes({:controller => 'users', :action => 'message', :slug => "cyrille" }, :path => "/user/cyrille/message" )
    assert_recognizes({:controller => 'admin/mass_emails', :action => 'send_test', :id => "2" }, :path => "/admin/mass_emails/2/send_test" )
    assert_recognizes({:controller => 'admin/mass_emails', :action => 'index'}, :path => "/admin/mass_emails" )
    assert_recognizes({:controller => 'categories', :action => 'region', :category_name => "coaching", :region_name => "wellington"}, :path => "/category/coaching/region/wellington" )
    assert_recognizes({:controller => 'subcategories', :action => 'region', :category_name => "coaching", :subcategory_name => "life-coaching", :region_name => "wellington"}, :path => "/category/coaching/life-coaching/wellington" )
    assert_recognizes({:controller => 'subcategories', :action => 'region', :category_name => "courses", :subcategory_name => "yoga", :region_name => "bay-of-plenty"}, :path => "/category/courses/yoga/bay-of-plenty" )
    assert_recognizes({:controller => 'subcategories', :action => 'show', :category_name => "coaching", :subcategory_name => "life-coaching"}, :path => "/category/coaching/life-coaching" )
    assert_recognizes({:controller => 'users', :action => 'create' }, :path => "/users", :method => "post" )
    assert_recognizes({:controller => 'expert_applications', :action => 'create' }, :path => "/expert_applications", :method => "post")
    assert_recognizes({:controller => 'expert_applications', :action => 'thank_you' }, :path => "/expert_applications/thank_you")
    assert_recognizes({:controller => 'admin/expert_applications', :action => 'index' }, :path => "/admin/expert_applications")
    assert_recognizes({:controller => 'admin/expert_applications', :action => 'publish', :id => "123"  }, :path => "/admin/expert_applications/123/publish")
    assert_recognizes({:controller => 'users', :action => 'unpublish', :id => "123"  }, :path => "/user_profiles/123/unpublish")
    assert_recognizes({:controller => 'payments', :action => 'index' }, :path => "/payments")
    assert_recognizes({:controller => 'users', :action => 'show', :name => "cyrille-bonnet", :main_expertise => "yoga", :region => "bay-of-plenty" }, :path => "/yoga/bay-of-plenty/cyrille-bonnet")
    assert_recognizes({:controller => 'how_tos', :action => 'edit', :id => "221", }, :path => "/how_tos/221/edit")
    assert_recognizes({:controller => 'users', :action => 'publish', :id => "221", }, :path => "/user_profiles/221/publish")
    assert_recognizes({:controller => 'users', :action => 'renew_membership' }, :path => "/users/renew_membership")
    assert_recognizes({:controller => 'search', :action => 'count_show_more_details', :id => "bam-show-more-details-12" }, :path => "/search/bam-show-more-details-12/count_show_more_details")
    assert_recognizes({:controller => 'search', :action => 'test'}, :path => "/search/test")
    assert_recognizes({:controller => 'tabs', :action => 'destroy', :id => "tab" }, :path => "/tabs/tab/destroy")
    assert_recognizes({:controller => 'tabs', :action => 'edit', :user_id => "cyrille-bonnet", :id => "tab-2" }, :path => "/users/cyrille-bonnet/tabs/tab-2/edit")
    assert_recognizes({:controller => 'users', :action => 'show', :name => "user-slug", :selected_tab_id => "tab-slug", :main_expertise => "yoga", :region => "bay-of-plenty" }, :path => "/yoga/bay-of-plenty/user-slug/tab-slug")
    assert_recognizes({:controller => 'tabs', :action => 'show', :id => "tab-slug", :user_id => "user-slug" }, :path => "/users/user-slug/tabs/tab-slug/show")
    assert_recognizes({:controller => 'tabs', :action => 'destroy', :id => "tab-slug", :user_id => "user-slug" }, :path => "/users/user-slug/tabs/tab-slug/destroy")
    assert_recognizes({:controller => 'tabs', :action => 'create', :format => "js"}, :path => "/tabs/create.js")
    assert_recognizes({:controller => 'tabs', :action => 'create'}, :path => "/tabs/create")
    assert_recognizes({:controller => 'articles', :action => 'publish', :id => "123"  }, {:path => "/articles/123/publish", :method => :post })
    assert_recognizes({:controller => 'users', :action => 'update', :id => "123"   }, {:path => "/users/123", :method => :put })
    assert_recognizes({:controller => 'users', :action => 'create'  }, {:path => "/users", :method => :post })
    assert_recognizes({:controller => 'regions', :action => 'districts', :format => "js", :id => "0"  }, "/regions/0.js/districts")
    assert_recognizes({:controller => 'users', :action => 'edit'  }, "/users/edit")
	end
end