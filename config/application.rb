require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Moeverdose
    class Application < Rails::Application
        # Initialize configuration defaults for originally generated Rails version.
        config.load_defaults 5.2

        config.i18n.fallbacks = [I18n.default_locale]

        # Settings in config/environments/* take precedence over those specified here.
        # Application configuration can go into files in config/initializers
        # -- all .rb files in that directory are automatically loaded after loading
        # the framework and any gems in your application.
        if Rails.env.production? or ENV["FORCE_DISCORD_BOT_START"] == "True"
            config.after_initialize do
                bot = DiscordBot.new()
                bot.run()
            end
        end
    end
end
