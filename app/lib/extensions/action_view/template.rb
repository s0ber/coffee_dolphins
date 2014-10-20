module ActionViewTemplateExtension
  extend ActiveSupport::Concern

  included do
    alias_method_chain :render, :iframe_streaming
  end

  def render_with_iframe_streaming(*args, &block)
    view = args.first

    # if this is a usual rendering, use default template rendering behavior
    unless view.view_renderer.__iframe_rendering
      render_without_iframe_streaming(*args, &block)
    else
      render_ajax_layout(*args, &block)
    end
  end

  def render_ajax_layout(view, locals, buffer=nil, &block)
    if locals[:template_type] == :layout
      flat_layout_render(view, locals, buffer, &block)
    elsif locals[:template_type] == :action
      flat_action_render(view, locals, &block)
    elsif view.output_buffer
      flat_partial_render(view, locals.merge(partial_id: SecureRandom.uuid), &block)
    end
  end

  def flat_layout_render(*args, &block)
    render_without_iframe_streaming(*args, &block)
  end

  def flat_action_render(view, locals, &block)
    view.view_renderer.__current_fiber = {fiber: nil, children: []}
    view.view_renderer.__current_fiber[:fiber] = Fiber.new do
      template = render_without_iframe_streaming(view, locals, nil, &block)

      partial = <<-FLAT_PARTIAL
\n<script type="text/javascript">parent.ijax.pushLayout('#{template}')</script>
FLAT_PARTIAL

      view.output_buffer << partial.html_safe
    end

    process_fiber(view, view.view_renderer.__current_fiber)

    return # return empty string, because we will modify output in fiber
  end

  def flat_partial_render(view, locals, &block)
    partial_id = SecureRandom.uuid
    view.output_buffer << "<div class=\"js-append_node\" id=\"append_#{partial_id}\"></div>".html_safe

    child_fiber = {fiber: nil, children: []}
    child_fiber[:fiber] = Fiber.new do
      template = render_without_iframe_streaming(view, locals, nil, &block)

      partial = <<-FLAT_PARTIAL
<script type="text/javascript">parent.ijax.pushFrame('#{partial_id}', '#{template}')</script>
FLAT_PARTIAL

      view.output_buffer << partial.html_safe
    end

    view.view_renderer.__current_fiber[:children].push child_fiber
    return # return empty string, because we will modify output in fiber
  end

  def process_fiber(view, fiber)
    fiber[:fiber].resume
    fiber[:children].each do |child_fiber|
      view.view_renderer.__current_fiber = child_fiber
      process_fiber(view, view.view_renderer.__current_fiber)
    end
  end

end

ActionView::Template.send(:include, ActionViewTemplateExtension)
