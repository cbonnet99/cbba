# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when you don't control
# web/app server and can't set it the proper way ENV['RAILS_ENV'] ||=
# 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION

ENV['RECAPTCHA_PUBLIC_KEY'] = '6Le_rwUAAAAAAIyiSLrIVnRr3gXvWgUxw6PQz3w2'
ENV['RECAPTCHA_PRIVATE_KEY'] = '6Le_rwUAAAAAAP-J7EBmIILaqLqhslt6K0h3m6Ns'

# #number of search results displayed per page
$search_results_per_page = 50

# #number of full members displayed per page
$full_members_per_page = 50

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers -- all
  # .rb files in that directory are automatically loaded. See
  # Rails::Configuration for more options.

  # Skip frameworks you're not going to use. To use Rails without a database you
  # must remove the Active Record framework. config.frameworks -= [
  # :active_record, :active_resource, :action_mailer ]

  # Specify gems that this application depends on. They can then be installed
  # with "rake gems:install" on new installations. config.gem "bj" config.gem
  # "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "aws-s3", :lib => "aws/s3"
  config.gem "transaction-simple", :lib => "transaction/simple", :version => "1.4.0"
  config.gem "color", :version => "1.4.0"
  config.gem "graticule", :version => "0.2.8"
  config.gem "activemerchant", :lib => "active_merchant", :version => "1.4.1"
  config.gem "pdf-writer", :lib => "pdf/writer", :version => "1.1.8"
  config.gem "tlconnor-xero_gateway", :lib => "xero_gateway",  :source => "http://gems.github.com"
  
  # Only load the plugins named here, in the order given. By default, all
  # plugins in vendor/plugins are loaded in alphabetical order. :all can be used
  # as a placeholder for all plugins not explicitly named config.plugins = [
  # :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs config.load_paths += %W(
  # #{RAILS_ROOT}/extras )

  config.load_paths += %W( #{RAILS_ROOT}/app/behaviors )

  # Force all environments to use the same logger level (by default production
  # uses :info, the others :debug) config.log_level = :debug

  # Make Time.zone default to the specified zone, and make Active Record store
  # time values in the database in UTC, and return them converted to the
  # specified local zone. Run "rake -D time" for a list of tasks for finding
  # time zone names. Comment line to use default local time.
  config.time_zone = 'Wellington'

  # Your secret key for verifying cookie session data integrity. If you change
  # this key, all old sessions will become invalid! Make sure the secret is at
  # least 30 characters and all random, no regular words or you'll be exposed to
  # dictionary attacks.
  config.action_controller.session = {
    :session_key => '_be_amazing_session',
    :secret      => 'c9ba017060e99fd4e23621a963dfe5d05e7975c732e622924b4a9b86a6b6d60ca6c067429f937c06675480f3181fc39f0d5328a73b559c3879cc2d9bee662c9d'
  }

  # Use the database for sessions instead of the cookie-based default, which
  # shouldn't be used to store highly confidential information (create the
  # session table with "rake db:sessions:create")
  config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test
  # database. This is necessary if your schema can't be completely dumped by the
  # schema dumper, like if you have constraints or database-specific column
  # types config.active_record.schema_format = :sql

  # Activate observers that should always be running
  config.active_record.observers = :user_observer

  config.action_mailer.smtp_settings = {
		:address  => "smtp2.vodafone.net.nz",
		:port  => 25,
		:domain  => "beamazing.co.nz",
		:authentication  => :login,
		:user_name  => "oosav@vodafone.net.nz",
		:password  => "urban74"
	}

end

ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!(
  :default => '%e %B %Y'
)
ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
  :default => '%e %B %Y %H:%M', :short => "%B %Y" )

$admins = [{:email => "sav@elevatecoaching.co.nz", :first_name => "David", :last_name => "Savage"},
  {:email => "cbonnet99@gmail.com", :first_name => "Cyrille", :last_name => "Bonnet" },
  {:email => "megan@beamazing.co.nz", :first_name => "Megan", :last_name => "Savage"},
  {:email => "julie@thatblindwoman.co.nz", :first_name => "Julie", :last_name => "Woods"},
  {:email => "norma@eurekacoaching.co.nz", :first_name => "Norma", :last_name => "Stein"}]

$number_articles_on_homepage = 3
$number_full_members_on_homepage = 3
$max_number_tabs = 6
$workflowable_stuff = ['Article', 'UserProfile', 'SpecialOffer']
# Ensure the gateway is in test mode
ActiveMerchant::Billing::Base.gateway_mode = :test
ActiveMerchant::Billing::Base.integration_mode = :test

#manage errors:
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  msg = instance.error_message
  title = msg.kind_of?(Array) ? '* ' + msg.join("\n* ") : msg
  "<div class=\"fieldWithErrors\" title=\"#{title}\">#{html_tag}</div>"
end

#I18n.locale = "en-NZ"
#I18n.load_path += Dir[ File.join(RAILS_ROOT, 'lib', 'locale', '*.{rb,yml}') ]

WhiteListHelper.attributes.merge %w(style)

######## Added try manually (will be included in Rails2.3), which means that the code below can
######## be deleted when Rails is upgraded to 2.3

class Object
  ##
  #   @person ? @person.name : nil
  # vs
  #   @person.try(:name)
  def try(method)
    send method if respond_to? method
  end
end
################# End try