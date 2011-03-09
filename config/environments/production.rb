# Settings specified here will take precedence over those in config/environment.rb

#Specify an asset host
ActionController::Base.asset_host = "assets%d.beamazing.co.nz"
config.action_controller.asset_host = AssetHostingWithMinimumSsl.new(
  "http://assets%d.beamazing.co.nz", # will serve non-SSL assets on http://assets
  "https://www.beamazing.co.nz"  # will serve SSL assets on https://www
)

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
$:.unshift File.join(RAILS_ROOT, "vendor", "SyslogLogger-1.4.0", "lib")
require 'syslog_logger'
config.logger = RAILS_DEFAULT_LOGGER = SyslogLogger.new('bam_production')

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false
 config.action_mailer.raise_delivery_errors = true
 config.action_mailer.delivery_method = :smtp
$hostname = "www.beamazing.co.nz"

config.after_initialize do
  ActiveMerchant::Billing::Base.mode = :production
  ::GATEWAY = PatchedGateway.new(
    :login => "BeAmazing",
    :password => "1081fc38"
  )
end

$xero_gateway = XeroGateway::Gateway.new(
  :customer_key => "M2IWNGY1OWY0YTK5NDY4MGI2MGI1OG",
  :api_key => "MDCYODC0ZMNJOTBJNDI1NZG0N2I0MZ",
  :xero_url => "https://network.xero.com/api.xro/1.0"
  )

ActionController::Base.cache_store = :mem_cache_store, "localhost"