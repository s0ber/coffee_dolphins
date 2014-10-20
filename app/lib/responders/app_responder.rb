module Responders
  class AppResponder < ActionController::Responder
    IFRAME_STREAMING = true

    def to_json
      if @default_response
        @default_response.call(options)
      else
        render json: {
          success: true,
          html: controller.render_to_string(controller.action_name, layout: false, formats: [:html])
        }
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

    def ijax_request_id
      controller.params[:i_req_id] || '0'
    end
  end
end
