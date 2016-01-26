require File.expand_path('../boot', __FILE__)

require 'csv'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CoffeeDolphinsApp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Moscow'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :ru

    config.autoload_paths += %W(
      #{config.root}/a_stream
      #{config.root}/lib
      #{config.root}/lib/validators
    )

    config.sass.preferred_syntax = :sass
    config.assets.paths << Rails.root.join('vendor', 'assets', 'components')

    # We don't want the default of everything that isn't js or css, because it pulls too many things in
    config.assets.precompile.shift

    config.assets.precompile += ['admin/application.js', 'admin/application.css', 'public/old_template/main_page.css', 'public/new_template/all.css', 'fontawesome-webfont.woff2']

    # color schemes for public landings
    %w(blue green pink red blue_light purple olive bronze cocoa aquamarine purple_light).each do |color|
      config.assets.precompile.push "public/old_template/color_schemes/#{color}.css"
    end

    # Explicitly register the extensions we are interested in compiling
    config.assets.precompile.push(Proc.new do |path|
      File.extname(path).in? [
        '.png',  '.gif', '.jpg', '.jpeg', '.ico', '.svg', # Images
        '.eot',  '.otf', '.svc', '.woff', '.ttf' # Fonts
      ]
    end)

    config.generators do |g|
      g.test_framework :rspec
    end

    require 'middleware/remotipart_accept_header'
    config.middleware.insert_after ActionDispatch::ParamsParser, Middleware::RemotipartAcceptHeader

    config.middleware.insert_before 0, 'Rack::Cors', :logger => (-> { Rails.logger }) do
      allow do
        origins 'http://localhost:4000'

        resource '*',
          :headers => :any,
          :methods => [:get, :post, :put, :delete],
          :credentials => true,
          :max_age => 0
      end
    end
  end
end
