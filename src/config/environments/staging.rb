ENV['GEM_PATH']="/usr/lib/ruby/gems/1.8/gems"
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

# mail settings
config.action_mailer.raise_delivery_errors = true
config.action_mailer.perform_deliveries = true
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
    :tls => true,
    :address => "smtp.gmail.com",
    :port => "587",
    :domain => "spicyelephant.com",
    :authentication => :plain,
    :user_name => "support@spicyelephant.com",
    :password => "mayhemmXOTmz"
}

SITE_URL = "staging.spicyelephant.com"

config.after_initialize do
  ActiveMerchant::Billing::Base.mode = :test
end

PAYPAL_LOGIN = 'craigb_1216863766_biz_api1.gmail.com'
PAYPAL_PASSWORD = '1216863771'
PAYPAL_SIGN = 'AiPC9BjkCyDFQXbSkoZcgqH3hpacAkYO2YoxUV6hx3LASXhhFHoa12RF'

