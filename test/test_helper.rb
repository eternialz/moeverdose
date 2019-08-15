require 'simplecov'
require 'codecov'

SimpleCov.start 'rails' do
    add_group 'Models', 'app/models'
    add_group 'Controllers', 'app/controllers'
end

SimpleCov.formatter = SimpleCov::Formatter::Codecov

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require_relative './file_helper'
require 'rails/test_help'
require 'minitest/pride'

FactoryBot::SyntaxRunner.class_eval do
    include ActionDispatch::TestProcess
end

class Minitest::Test
    include FactoryBot::Syntax::Methods
end

class ActiveSupport::TestCase
    ActiveRecord::Migration.check_pending!
end

def assert_xhr_redirected_to(url)
    assert_equal url, @response.headers['X-Xhr-Redirect-Url']
end
