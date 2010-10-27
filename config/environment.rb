# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
#RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  config.gem "sqlite3-ruby", :lib => "sqlite3"
  config.gem "rspec", :lib => false
  config.gem "rspec-rails", :lib => false
  config.gem "solr-ruby", :lib => "solr"
  config.gem "twitter", :version => "~> 0.8.4"
  config.gem "remarkable_rails", :lib => false
  config.gem "elkinsware-erubis_rails_helper", :lib => "erubis_rails_helper", :source => "http://gems.github.com"
  config.gem "cosine-active_record_encoding", :lib => "active_record_encoding", :source => "http://gems.github.com"
  # config.gem "aws-s3", :lib => "aws/s3"

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
  config.active_record.observers = :page_cache_sweeper

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  #config.time_zone = 'Tokyo'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
end

#require 'erubis/helpers/rails_helper'
Erubis::Helpers::RailsHelper.engine_class = Erubis::FastEruby
#Erubis::Helpers::RailsHelper.init_properties = {}
#Erubis::Helpers::RailsHelper.show_src = nil
#Erubis::Helpers::RailsHelper.preprocessing = true

require File.join(File.dirname(__FILE__), 'pp_setting')

require 'memcache'
memcache_option = {:namespace => "thumbnail", :timeout => 3}
CACHE = MemCache.new(MEMCACHE_SERVER, memcache_option)

