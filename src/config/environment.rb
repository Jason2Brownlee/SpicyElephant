if ENV['GEM_PATH'].nil?
  ENV['GEM_PATH'] = "/usr/lib/ruby/gems/1.8/gems"
else
   ENV['GEM_PATH']+=":/usr/lib/ruby/gems/1.8/gems"
end
# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.1.1' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

# enable acts as ferrent, lucene port integration
#require 'acts_as_ferret'

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use. To use Rails without a database
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Specify gems that this application depends on. 
  # They can then be installed with "rake gems:install" on new installations.
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "aws-s3", :lib => "aws/s3"
  # config.gem "logging" :verion => '0.7.1'
  # config.gem "ruby-openid"
  
    config.gem "hobofields"
    config.gem "hobosupport"
    config.gem "html5"
    config.gem "avatar"

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]
  
  # only the plugins we are using
  config.plugins = [ :action_mailer_optional_tls, :active_merchant, :will_paginate, :tiny_mce_gzip, :xss_terminate, :open_id_authentication, "toland-app_version", :restful_authentication, :jrails]
# excluded: :exiguous_format, :ext_scaffold, :hobofields, :hobosupport, :navigation_helper


  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Uncomment to use default local time.
  config.time_zone = 'UTC'

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_learning_session',
    :secret      => 'ea98311c3064d8cc0b2da66d0a6c366c8f7cdf10045d4d39c40598d741ca6ab359a34f919e36e4e25bd5a0b8317872aaadb1f2b292893a6316fa93247938ffbe'
  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with "rake db:sessions:create")
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector
  
  # application sends email to the user after registration, activation, etc.
  config.active_record.observers = :user_observer
    
end


# the limit on the number of decks in the system in freemium mode
FREEMIUM_TOTAL_DECKS=5

# the name of the deck about the site
# NOTE: if the description changes, this name has to be updated
DEFAULT_DECK_ABOUT = "About Spicy Elephant"
# the name of the user that owns the default decks
DEFAULT_USER_NAME = "spicyelephant"
# used in the feedback form
FEEDBACK_RECIPIENT = "dev@spicyelephant.com"
SUPPORT_EMAIL = "support@spicyelephant.com"
