ActionController::Routing::Routes.draw do |map|
  map.resources :categories

  map.resources :articles

  map.resources :regions
 
  # Restful Authentication Rewrites
  map.search '/search/:id/:action', :controller => 'search'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.forgot_password '/forgot_password', :controller => 'passwords', :action => 'new'
  map.change_password '/change_password/:reset_code', :controller => 'passwords', :action => 'reset'
  
  # Restful Authentication Resources
  map.resources :users
  map.resources :passwords
  map.resource :session
	map.default ':controller/:id.:format/:action'
  # Home Page
  map.root :controller => 'articles', :action => 'index'
end
