# Settings specified here will take precedence over those in config/environment.rb

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

# Email settings
config.action_mailer.raise_delivery_errors = true
config.action_mailer.perform_deliveries = false
ActionMailer::Base.delivery_method = :test


SITE_URL = "localhost:3000"


config.after_initialize do
  ActiveMerchant::Billing::Base.mode = :test
end

PAYPAL_LOGIN = 'craigb_1216863766_biz_api1.gmail.com'
PAYPAL_PASSWORD = '1216863771'
PAYPAL_SIGN = 'AiPC9BjkCyDFQXbSkoZcgqH3hpacAkYO2YoxUV6hx3LASXhhFHoa12RF'

