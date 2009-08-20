ActionController::Routing::Routes.draw do |map|
  map.articles_for_subcategory '/articles/subcategory/:subcategory_slug', :controller => "articles", :action => "index_for_subcategory" 
  map.resources :search_results, :path_prefix => "/admin", :controller => "admin/search_results"
  map.action_search_results '/admin/search_results/:id/:action', :controller => "admin/search_results"
  map.resources :mass_emails, :path_prefix => "/admin", :controller => "admin/mass_emails"
  map.action_mass_emails '/admin/mass_emails/:id/:action', :controller => "admin/mass_emails"
  map.action_users '/admin/users/:action', :controller => "admin/users"
  map.resources :adminusers, :path_prefix => "/admin", :controller => "admin/users"
  map.action_id_users '/admin/users/:id/:action', :controller => "admin/users"
  map.resources :messages
  map.resources :full_members
  map.resources :resident_experts
  map.resources :invoices
  map.resources :orders
  map.resources :contacts
  map.resources :subcategories
  map.resources :categories
  map.how_tos_show '/how-tos/:selected_user/:id', :controller => "how_tos", :action => "show"
  map.how_tos_action '/how-tos/:selected_user/:id/:action', :controller => "how_tos"
  map.resources :how_tos
  map.articles_show '/amazing-articles/:selected_user/:id', :controller => "articles", :action => "show"
  map.articles_action '/bam-articles/:selected_user/:id/:action', :controller => "articles"
  map.resources :articles
  map.resources :regions

  map.gift_vouchers_show '/gift-vouchers/:selected_user/:id', :controller => "gift_vouchers", :action => "show" 
  # map.gift_vouchers_action '/gift-vouchers/:selected_user/:id/:action', :controller => "gift_vouchers"
  map.resources :gift_vouchers
  
  map.special_offers_show '/special-offers/:selected_user/:id', :controller => "special_offers", :action => "show"
  map.special_offers_show_format '/special-offers/:selected_user/:id.:format', :controller => "special_offers", :action => "show"
  # map.special_offers_action '/special-offers/:selected_user/:id/:action', :controller => "special_offers"
  map.resources :special_offers
  
  map.thank_you_expert_applications '/expert_applications/thank_you', :controller => 'expert_applications', :action => "thank_you"
  map.resources :expert_applications

  map.contact '/contact', :controller => "search", :action => "contact"
  map.customerror '/customerror', :controller => "search", :action => "customerror"
  map.notfound '/notfound', :controller => "search", :action => "notfound"
  map.whyjoin '/whyjoin', :controller => "search", :action => "whyjoin"
  map.about '/about', :controller => "search", :action => "about"  
  map.goals '/goals', :controller => "search", :action => "goals"  
  map.team '/team', :controller => "search", :action => "team"  
  map.origins '/origins', :controller => "search", :action => "origins"  
  map.disclaimer '/disclaimer', :controller => "search", :action => "disclaimer"  
  map.terms '/terms', :controller => "search", :action => "terms"  
  map.search '/search/what/:what/where/:where', :controller => "search", :action => "search"
  map.search_what '/search/what/:what', :controller => "search", :action => "search"
  map.search_where '/search/where/:where', :controller => "search", :action => "search"
  map.action_tab '/tabs/:action', :controller => 'tabs'
  map.action_tab_with_id '/tabs/:id/:action', :controller => 'tabs'
	map.category_region '/category/:category_slug/region/:region_slug', :controller => "categories", :action => "region"
	map.subcategory_region '/category/:category_slug/:subcategory_slug/:region_slug', :controller => "subcategories", :action => "region"
	map.subcategory '/category/:category_slug/:subcategory_slug', :controller => "subcategories", :action => "show"
  map.user_slug_action '/user/:slug/:action', :controller => "users"
  map.full_user '/:main_expertise_slug/:region/:name', :controller => "users", :action => "show", :requirements => {:region => /[a-z|A-Z|_|-]+/, :main_expertise_slug => /[a-z|A-Z|_|-]+/}
  map.payment_action '/payments/:action', :controller => "payments", :requirements => {:action => /[a-z|A-Z|_]+/}
  map.payment_action_with_id '/payments/:id/:action', :controller => "payments", :requirements => {:action => /edit|edit_debit|thank_you|thank_you_direct_debit|thank_you_renewal|thank_you_resident_expert/}
  map.resources :payments
	map.expert_applications_action 'admin/expert_applications/:action', :controller => "admin/expert_applications"
	map.expert_applications_action_with_id 'admin/expert_applications/:id/:action', :controller => "admin/expert_applications"
	map.payments_action_with_id 'admin/payments/:id/:action', :controller => "admin/payments"
	map.reviewer 'reviewer/:action', :controller => "admin/reviewer"
	map.category '/category/:category_slug', :controller => "categories", :action => "show"
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
  map.user_tabs '/:main_expertise_slug/:region/:name/:selected_tab_id', :controller => 'users', :action => "show", :requirements => {:region => /[a-z|A-Z|_| |-]+/}
  map.user_thank_you_resident_application '/users/thank_you_resident_application', :controller => 'users', :action => "thank_you_resident_application"
  map.user_special_offers '/users/special_offers', :controller => 'users', :action => "special_offers"
  map.user_gift_vouchers '/users/gift_vouchers', :controller => 'users', :action => "gift_vouchers"
  map.user_articles '/users/articles', :controller => 'users', :action => "articles"
  map.user_stats '/users/stats', :controller => 'users', :action => "stats"
  map.user_renew_membership '/users/renew_membership', :controller => 'users', :action => "renew_membership"
  map.user_renew_resident '/users/renew_resident', :controller => 'users', :action => "renew_resident"
  map.user_pay_resident '/users/pay_resident', :controller => 'users', :action => "pay_resident"
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
