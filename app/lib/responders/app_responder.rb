module Responders
  class AppResponder < ActionController::Responder
    IFRAME_STREAMING = true

    def to_json
      if @default_response
        @default_response.call(options)
      else
        render_options = {json: undecorate_model(resource)}
        [:serializer, :each_serializer].each do |k|
          render_options[k] = options[k] if options[k]
        end
        render_options[:meta] ||= {}
        render_options[:meta].merge!(pagination_meta(resource)) if paginated?(resource)
        render(render_options)
      end
    end

    def to_al
      render({action: controller.action_name,
              layout: IFRAME_STREAMING ? 'ajax_layout' : 'iframe_layout',
              locals: {ijax_request_id: ijax_request_id},
              formats: [:html],
              iframe_stream: IFRAME_STREAMING})
    end

    private

    def undecorate_model(resource)
      if resource.is_a?(Draper::Decorator) || resource.is_a?(Draper::CollectionDecorator)
        resource.send(:object)
      else
        resource
      end
    end

    def ijax_request_id
      controller.params[:i_req_id] || '0'
    end

    def paginated?(resource)
      resource.respond_to?(:current_page) &&
      resource.respond_to?(:total_pages) &&
      resource.respond_to?(:size)
    end

    def pagination_meta(resource)
      {
        current_page: resource.current_page,
        next_page: resource.next_page,
        prev_page: resource.prev_page,
        total_pages: resource.total_pages,
        total_count: resource.total_count
      }
    end
  end
end
