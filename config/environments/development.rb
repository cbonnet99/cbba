# Settings specified here will take precedence over those in config/environment.rb
require 'xero_gateway'

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

config.action_controller.session[:domain] = '.localhost.com'

#do not send email in dev environment
config.action_mailer.delivery_method = :test

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

config.after_initialize do
  ActiveMerchant::Billing::Base.mode = :test
  ::GATEWAY = PatchedGateway.new(
    :login => "BeAmazingDev",
    :password => "6229c3d7"
  )
end

$xero_gateway = XeroGateway::Gateway.new(
  :customer_key => "ZDYWYWY1ODG1ZTG0NGQ5ZTKYNGZMYM",
  :api_key => "MDCYODC0ZMNJOTBJNDI1NZG0N2I0MZ",
  :xero_url => "https://networktest.xero.com/api.xro/1.0"
  )