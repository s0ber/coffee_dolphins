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
      #{config.root}/lib
      #{config.root}/lib/validators
    )

    config.sass.preferred_syntax = :sass
    config.assets.paths << Rails.root.join('vendor', 'assets', 'components')

    # We don't want the default of everything that isn't js or css, because it pulls too many things in
    config.assets.precompile.shift

    config.assets.precompile += ['admin/application.js', 'admin/application.css']

    # color schemes for public landings
    %w(blue green pink red test).each do |color|
      config.assets.precompile.push "public/color_schemes/#{color}.css"
    end

    # Explicitly register the extensions we are interested in compiling
    config.assets.precompile.push(Proc.new do |path|
      File.extname(path).in? [
        '.png',  '.gif', '.jpg', '.jpeg', '.svg', # Images
        '.eot',  '.otf', '.svc', '.woff', '.ttf' # Fonts
      ]
    end)

  end
end
