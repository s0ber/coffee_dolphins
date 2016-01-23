module Responders
  class AppResponder < ActionController::Responder
    IFRAME_STREAMING = true

    def to_json
      if @default_response
        @default_response.call(options)
      else
        render json: undecorate_model(resource), meta: options
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
  end
end
