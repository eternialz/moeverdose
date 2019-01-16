ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "minitest/pride"
require 'database_cleaner'

# To add Capybara feature tests add `gem "minitest-rails-capybara"`
# to the test group in the Gemfile and uncomment the following:
# require "minitest/rails/capybara"

# Uncomment for awesome colorful output

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

(ActiveRecord::Base.connection.tables - %w{schema_migrations}).each do |table_name|
  ActiveRecord::Base.connection.execute "TRUNCATE TABLE #{table_name};"
end

def sample_path(name='sample.png')
    Rails.root.join('test', 'images', name)
end

def sample_file(name='sample.png')
    fixture_file_upload(sample_path(name), 'image/png')
end

