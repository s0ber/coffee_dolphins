source 'https://rubygems.org'

group :production do
  gem 'unicorn', '~> 4.8.3'
end

group :development do
  gem 'unicorn-rails'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.0'
  gem 'shoulda-matchers', require: false
  gem 'factory_girl_rails', '~> 4.0'
  gem 'ffaker'
  gem 'database_cleaner'
  gem 'fuubar'
  gem 'spring-commands-rspec'
  gem 'guard-rspec', require: false
end

gem 'pg'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.8'

# form objects
gem 'active_data'

# models serialization
gem 'active_model_serializers', '0.10.0.rc3'

# configure CORS
gem 'rack-cors', :require => 'rack/cors'

# Use Slim for templates
gem "slim-rails"
# javascript templates
gem 'ejs'
# Use SASS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Font-Awesome icons
gem 'font-awesome-rails'
# Sass Images Helpers
gem 'rails-sass-images'

# pure-css
gem "pure-css-rails"

# Fix for rails console under ubuntu 14.04
gem 'rb-readline'

# Filter generated paths
gem 'routing-filter', '0.4.0.pre'

# automatically turn http:// text into links
gem 'rails_autolink'

# images upload
gem 'rmagick', '2.13.2', require: 'RMagick'  # ImageMagick bindings
gem 'carrierwave'

# automatically optimize images sizes
gem 'carrierwave-imageoptimizer'

# Automatically add vendor prefixes for styles
gem 'autoprefixer-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

gem 'colorize', require: false

# Custom responders
gem 'responders'

# Authentification
gem 'sorcery'

# Model enhancements
gem 'acts_as_list', git: 'https://github.com/swanandp/acts_as_list.git' #orderable model

# Forms
gem 'simple_form', '~> 3.0.2'
gem 'neo_form', path: 'gems/neo_form'

# Ajax file uploads for rails forms
gem 'remotipart', '~> 1.2'

# Decorating models with presentation logic
gem 'draper', '~> 1.3'

# Pagination
gem 'kaminari'

# Pass variables to front-end
gem 'gon'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
gem 'capistrano', '~> 3.2.1'
gem 'capistrano-bundler', '~> 1.1.3'
gem 'capistrano-rails', '~> 1.1.2'
gem 'capistrano3-unicorn', '~> 0.2.1'

# Add this if you're using rbenv
gem 'capistrano-rbenv', github: "capistrano/rbenv"

# Use debugger
# gem 'debugger', group: [:development, :test]
gem 'pry-byebug', group: [:development, :test]
gem 'pry-rails', group: [:development, :test]

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
end

# Misc
gem 'rails_config'
