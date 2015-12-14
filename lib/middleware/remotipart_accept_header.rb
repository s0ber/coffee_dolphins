module Middleware
  # It's an addition to Remotipart::Middleware to make it compatible with jquery.iframe-transport.js used in the project.
  # TODO: Remove this middleware if the issue is fixed: https://github.com/JangoSteve/remotipart/issues/125
  class RemotipartAcceptHeader
    def initialize app
      @app = app
    end

    def call env
      params = Rack::Request.new(env).params

      if params && params['X-HTTP-Accept']
        env['HTTP_ACCEPT'] = params['X-HTTP-Accept']
      end

      @app.call(env)
    end
  end
end
