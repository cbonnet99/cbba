ActionController::Routing::Routes.draw do |map|
  map.resources :gift_vouchers
  map.resources :full_members
  map.resources :resident_experts
  map.resources :invoices
  map.resources :special_offers
  map.resources :orders
  map.resources :contacts
  map.resources :payments
  map.resources :subcategories
  map.resources :categories
  map.resources :how_tos
  map.resources :articles
  map.resources :regions


  map.thank_you_expert_applications '/expert_applications/thank_you', :controller => 'expert_applications', :action => "thank_you"
  map.resources :expert_applications
  
  map.action_tab '/tabs/:action', :controller => 'tabs'
  map.action_tab_with_id '/tabs/:id/:action', :controller => 'tabs'
	map.category_region '/category/:category_name/region/:region_name', :controller => "categories", :action => "region"
	map.subcategory_region '/category/:category_name/:subcategory_name/:region_name', :controller => "subcategories", :action => "region"
	map.subcategory '/category/:category_name/:subcategory_name', :controller => "subcategories", :action => "show"
  map.full_user '/:main_expertise/:region/:name', :controller => "users", :action => "show", :requirements => {:region => /[a-z|A-Z|_| |-]+/}
  map.payment_action '/payments/:action', :controller => "payments", :requirements => {:action => /[a-z|A-Z|_]+/}
	map.expert_applications_action 'admin/expert_applications/:action', :controller => "admin/expert_applications"
	map.expert_applications_action_with_id 'admin/expert_applications/:id/:action', :controller => "admin/expert_applications"
	map.reviewer 'reviewer/:action', :controller => "admin/reviewer"
	map.category '/category/:category_name', :controller => "categories", :action => "show"
  map.fuzzy_search_action '/fuzzy_search', :controller => 'search', :action => "fuzzy_search"
  map.search_action '/search/:action', :controller => 'search'
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
  map.user_thank_you_resident_application '/users/thank_you_resident_application', :controller => 'users', :action => "thank_you_resident_application"
  map.user_tabs '/:main_expertise/:region/:name/:selected_tab_id', :controller => 'users', :action => "show", :requirements => {:region => /[a-z|A-Z|_| |-]+/}
  map.user_special_offers '/users/special_offers', :controller => 'users', :action => "special_offers"
  map.user_gift_vouchers '/users/gift_vouchers', :controller => 'users', :action => "gift_vouchers"
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
  map.user_profile_action '/user_profiles/:id/:action', :controller => 'users'
  map.user_new_photo '/users/new_photo', :controller => 'users', :action => "new_photo"
  map.user_create_photo '/users/create_photo', :controller => 'users', :action => "create_photo"
  
  map.resources :users
  map.resources :passwords
  map.resource :session
	map.default_no_format ':controller/:id/:action'
	map.default ':controller/:id.:format/:action'
  # Home Page
  map.root :controller => 'search', :action => 'index'
end
