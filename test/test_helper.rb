ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require_relative './file_helper'
require 'rails/test_help'
require "minitest/pride"
require 'simplecov'
require 'codecov'

SimpleCov.start do
  add_group 'Models', 'app/models'
  add_group 'Controllers', 'app/controllers'
end

SimpleCov.formatter = SimpleCov::Formatter::Codecov


FactoryBot::SyntaxRunner.class_eval do
  include ActionDispatch::TestProcess
end

class Minitest::Test
  include FactoryBot::Syntax::Methods
end

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
end
