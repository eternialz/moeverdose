require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Moeverdose
    class Application < Rails::Application
        # Initialize configuration defaults for originally generated Rails version.
        config.load_defaults 6.0

        # config/application.rb
        config.generators do |g|
            g.test_framework :minitest, spec: false, fixture: false
            g.fixture_replacement :factory_bot
            g.stylesheets     false
            g.javascripts     false
            g.helper          false
            g.channel         assets: false
        end

        config.i18n.fallbacks = [I18n.default_locale]

        # View path
        config.paths['app/views'] = 'frontend/views'

        config.to_prepare do
            Devise::Mailer.layout 'mailer'
        end
    end
end
