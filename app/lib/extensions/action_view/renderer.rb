module ActionViewRendererExtension
  extend ActiveSupport::Concern

  attr_reader :__iframe_rendering
  attr_accessor :__current_fiber

  def render_iframe_body(context, options)
    @__iframe_rendering = true

    if options[:partial]
      ActionView::IframeStreamingPartialRenderer.new(@lookup_context).render(context, options, nil)
    else
      ActionView::IframeStreamingTemplateRenderer.new(@lookup_context).render(context, options)
    end
  end
end

ActionView::Renderer.send(:include, ActionViewRendererExtension)
