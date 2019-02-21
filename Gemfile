source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby
gem 'webpacker', '~> 3.5'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
gem 'mini_magick', '~> 4.8'
gem 'active_storage_validations'
gem 'mime-types', require: 'mime/types/full'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Devise for user authentications
gem "devise"

# Pagination plugin
gem 'kaminari'

# autoprefixer plugin for css/sass
gem "autoprefixer-rails"

# Font-awesome
gem "font-awesome-rails"

# Discord BOT
gem "discordrb"

# Httparty
gem "httparty"

#Twitter
gem "twitter"
gem "rufus-scheduler"

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
    # Call 'byebug' anywhere in the code to stop execution and get a debugger console
    gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

    # Open mails in the browser 
    gem "letter_opener"

    # PRY
    gem "rb-readline"
    gem "pry"
end

group :development do
    # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
    gem 'web-console', '>= 3.3.0'
    gem 'listen', '>= 3.0.5', '< 3.2'
    # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
    gem 'spring'
    gem 'spring-watcher-listen', '~> 2.0.0'
    # Performance monitoring
    gem 'rack-mini-profiler'
    gem 'stackprof'
    gem 'flamegraph'
    gem 'bullet'
end

group :test do
    # Gems for test
    gem 'factory_bot_rails'
    gem 'faker', github: 'stympy/faker'
    gem 'minitest-rails', '>= 2.0'
    gem 'database_cleaner'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
