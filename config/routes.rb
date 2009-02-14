ActionController::Routing::Routes.draw do |map|
  map.resources :special_offers

  map.resources :orders


  map.action_tab '/tabs/:action', :controller => 'tabs'
  map.action_tab_with_id '/tabs/:id/:action', :controller => 'tabs'
  map.full_user '/:main_expertise/:region/:name', :controller => "users", :action => "show", :requirements => {:region => /[a-z|A-Z|_| |-]+/ }

  map.resources :contacts


  map.payment_action '/payments/:action', :controller => "payments", :requirements => {:action => /[a-z|A-Z|_]+/}
  map.resources :payments

  map.resources :subcategories

  map.resources :categories

  map.resources :how_tos

  map.resources :articles

  map.resources :regions
 
  # Restful Authentication Rewrites
	map.reviewer 'reviewer/:action', :controller => "reviewer"
	map.category '/category/:category_name', :controller => "categories", :action => "show"
	map.subcategory '/category/:category_name/subcategory/:subcategory_name', :controller => "subcategories", :action => "show"
  map.test_search_action '/search/test', :controller => 'search', :action => "test"
  map.search_action '/search', :controller => 'search', :action => "search"
  map.search_action '/fuzzy_search', :controller => 'search', :action => "fuzzy_search"
  map.search_action_id '/search/:id/:action', :controller => 'search'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.action_tab_format '/tabs/:action.:format', :controller => 'tabs'
  map.action_tab_with_user '/users/:user_id/tabs/:id/:action', :controller => 'tabs'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.signup_intro '/signup_intro', :controller => 'users', :action => 'intro'
  map.signup_newsletter '/signup_newsletter', :controller => 'contacts', :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.forgot_password '/forgot_password', :controller => 'passwords', :action => 'new'
  map.change_password '/change_password/:reset_code', :controller => 'passwords', :action => 'reset'
  map.update_after_forgetting '/update_after_forgetting', :controller => 'passwords', :action => 'update_after_forgetting'
  map.user_tabs '/:main_expertise/:region/:name/:selected_tab_id', :controller => 'users', :action => "show", :requirements => {:region => /[a-z|A-Z|_| |-]+/}
  map.user_special_offers '/users/special_offers', :controller => 'users', :action => "special_offers"
  map.user_articles '/users/articles', :controller => 'users', :action => "articles"
  map.user_renew_membership '/users/renew_membership', :controller => 'users', :action => "renew_membership"
  map.upgrade_to_full_membership '/users/upgrade_to_full_membership', :controller => 'users', :action => "upgrade_to_full_membership"
  map.user_howtos '/users/howtos', :controller => 'users', :action => "howtos"
  map.user_edit_pwd '/users/edit_password', :controller => 'users', :action => "edit_password"
  map.user_update_pwd '/users/update_password', :controller => 'users', :action => "update_password"
  map.user_edit '/users/edit', :controller => 'users', :action => "edit"
  map.compare_memberships '/users/compare_memberships', :controller => 'users', :action => "compare_memberships"
  map.more_about_free_listing '/users/more_about_free_listing', :controller => 'users', :action => "more_about_free_listing"
  map.more_about_full_membership '/users/more_about_full_membership', :controller => 'users', :action => "more_about_full_membership"
  map.more_about_resident_expert '/users/more_about_resident_expert', :controller => 'users', :action => "more_about_resident_expert"
  map.user_membership '/users/membership', :controller => 'users', :action => "membership"
  map.user_publish '/users/publish', :controller => 'users', :action => "publish"
  map.user_profile_publish '/user_profiles/:id/publish', :controller => 'users', :action => "publish"
  map.user_new_photo '/users/new_photo', :controller => 'users', :action => "new_photo"
  map.user_create_photo '/users/create_photo', :controller => 'users', :action => "create_photo"
  
  # Restful Authentication Resources
  map.resources :users
  map.resources :passwords
  map.resource :session
	map.default_no_format ':controller/:id/:action'
	map.default ':controller/:id.:format/:action'
  # Home Page
  map.root :controller => 'search', :action => 'index'
end
