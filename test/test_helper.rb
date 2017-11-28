ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"

module AroundEachTest
  def before_setup
    super
    Mongoid.purge!
  end
end


class Minitest::Test
  include AroundEachTest
end

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods
end

def sample_file(name='sample.png')
    File.new("#{Rails.root}/test/images/#{name}")
end
