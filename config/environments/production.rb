# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
 config.action_mailer.raise_delivery_errors = false

$hostname = "75.101.132.186:9000"
$paypal_server = "https://www.paypal.com/nz/cgi-bin/webscr"
$public_certificate="production-pubcert.pem"
$private_key="production-prvkey.pem"
$paypal_certificate="paypal_cert_production.pem"
$paypal_cert_id = "P66P32N232MHL"

ActiveMerchant::Billing::Base.gateway_mode = :production
ActiveMerchant::Billing::Base.integration_mode = :production
ActiveMerchant::Billing::PaypalGateway.pem_file =
 File.read(File.dirname(__FILE__) + "/../../paypal/#{$paypal_certificate}")
