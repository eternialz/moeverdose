require_relative 'boot'



require "action_controller/railtie"
require "action_cable/engine"
require "active_model/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
module Moeverdose
    class Application < Rails::Application
        # Settings in config/environments/* take precedence over those specified here.
        # Application configuration should go into files in config/initializers
        # -- all .rb files in that directory are automatically loaded.

        config.exceptions_app = self.routes

        if !(Rails.env.development?) or ENV["FORCE_DISCORD_BOT_START"] == "True"
            config.after_initialize do
            bot = DiscordBot.new()
                bot.run()
            end
        end
    end
end
