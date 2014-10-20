module IframeStreaming
  extend ActiveSupport::Concern

  protected

    # Set proper cache control and transfer encoding when streaming
    def _process_options(options) #:nodoc:
      super
      if options[:iframe_stream]
        if env["HTTP_VERSION"] == "HTTP/1.0"
          options.delete(:iframe_stream)
        else
          headers["Cache-Control"] ||= "no-cache"
          headers["Transfer-Encoding"] = "chunked"
          headers.delete("Content-Length")
        end
      end
    end

    # Call render_body if we are streaming instead of usual +render+.
    def _render_template(options) #:nodoc:
      if options.delete(:iframe_stream)
        lookup_context.rendered_format = nil if options[:formats]
        Rack::Chunked::Body.new view_renderer.render_iframe_body(view_context, options)
      else
        super
      end
    end
end
