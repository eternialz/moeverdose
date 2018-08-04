ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"

module AroundEachTest
  def before_setup
    super
    Mongoid::Config.purge!
  end
end


class Minitest::Test
  include AroundEachTest
  include FactoryBot::Syntax::Methods
end

class ActiveSupport::TestCase
end

def sample_path(name='sample.png')
    "#{Rails.root}/test/images/#{name}"
end

def sample_file(name='sample.png')
    File.new(sample_path)
end
Minitest::Rails::TestUnit = Rails::TestUnit
