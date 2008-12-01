ActionController::Routing::Routes.draw do |map|
  map.resources :subcategories

  map.resources :categories

  map.resources :articles

  map.resources :regions
 
  # Restful Authentication Rewrites
	map.reviewer 'reviewer/:action', :controller => "reviewer"
	map.category '/category/:category_name', :controller => "categories", :action => "show"
	map.subcategory '/category/:category_name/subcategory/:subcategory_name', :controller => "subcategories", :action => "show"
  map.search_action '/search', :controller => 'search', :action => "search"
  map.search_action '/search/:id/:action', :controller => 'search'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.whyjoin '/whyjoin', :controller => 'users', :action => 'why_join'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.forgot_password '/forgot_password', :controller => 'passwords', :action => 'new'
  map.change_password '/change_password/:reset_code', :controller => 'passwords', :action => 'reset'
  map.update_after_forgetting '/update_after_forgetting', :controller => 'passwords', :action => 'update_after_forgetting'
  map.user_profile '/users/profile', :controller => 'users', :action => "profile"
  map.user_edit_pwd '/users/edit_password', :controller => 'users', :action => "edit_password"
  map.user_edit_pwd '/users/update_password', :controller => 'users', :action => "update_password"
  map.user_edit '/users/edit', :controller => 'users', :action => "edit"
  
  # Restful Authentication Resources
  map.resources :users
  map.resources :passwords
  map.resource :session
	map.default_no_format ':controller/:id/:action'
	map.default ':controller/:id.:format/:action'
  # Home Page
  map.root :controller => 'search', :action => 'index'
end
