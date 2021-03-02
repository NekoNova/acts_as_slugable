# Configure Rails Environment
$:.unshift(File.dirname(__FILE__) + '/../lib')
ENV['RAILS_ENV'] = 'test'

require 'rails'
require 'rails/test_help'
require 'sqlite3'
require 'active_record'
require 'active_support'
require 'yaml'
require 'acts_as_slugable'

Rails.backtrace_cleaner.remove_silencers!

ActiveSupport::TestCase.test_order = :random if ActiveSupport::TestCase.respond_to?(:test_order=)

# Load fixtures from the engine
if ActiveSupport::TestCase.method_defined?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path('../fixtures', __FILE__)
end

# run the database migrations
config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))

ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + '/debug.log')
ActiveRecord::Base.establish_connection(config[ENV['RAILS_ENV']])
load(File.dirname(__FILE__) + '/schema.rb')

