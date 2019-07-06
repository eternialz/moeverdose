require 'coveralls'
Coveralls.wear!

ENV["RAILS_ENV"] = "test"
require "rails/generators/test_case"
require "minitest/rails"
require "minitest/pride"
require 'database_cleaner'

# To add Capybara feature tests add `gem "minitest-rails-capybara"`
# to the test group in the Gemfile and uncomment the following:
# require "minitest/rails/capybara"

### rails/test_help
abort("Abort testing: Your Rails environment is running in production mode!") if Rails.env.production?

require "active_support/test_case"
require "action_controller"
require "action_controller/test_case"
require "action_dispatch/testing/integration"

require "active_support/testing/autorun"

ActiveSupport.on_load(:action_controller_test_case) do
  def before_setup # :nodoc:
    @routes = Rails.application.routes
    super
  end
end

ActiveSupport.on_load(:action_dispatch_integration_test) do
  def before_setup # :nodoc:
    @routes = Rails.application.routes
    super
  end
end

### end rails/test_help

DatabaseCleaner.strategy = :transaction

module AroundEachTest
  def before_setup
    super
    DatabaseCleaner.clean
    DatabaseCleaner.start
  end
end

FactoryBot::SyntaxRunner.class_eval do
  include ActionDispatch::TestProcess
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  include FactoryBot::Syntax::Methods
  include AroundEachTest
  # Add more helper methods to be used by all tests here...
end

def sample_path(name='sample.png')
    Rails.root.join('test', 'images', name)
end

def sample_file(name='sample.png')
    fixture_file_upload(sample_path(name), 'image/png')
end

