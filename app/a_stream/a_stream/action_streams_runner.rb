module AStream
  class ActionStreamsRunner

    def initialize(performer:, controller:)
      @performer, @controller = performer, controller
    end

    def run(action_streams)
      request_data = {}
      response = {}

      action_streams.each do |request|
        response.merge!(run_action(request))
      end

      response
    end

    def run_action(request, stream_response = {})
      action = request.runner.new(controller: @controller)
      response = action.perform_read(@performer, request.query)
      status, body = parse_response(response)

      if status == :ok && request.type == :post
        response = action.perform_update(@performer, request.query)
        status, body = parse_response(response)
      end

      response = ActionResponse.new(status: status, body: body, request: request)
      namespace, action_name = request.runner.action_name.split('#')

      stream_response[:"#{namespace}_#{action_name}"] =
        status == :ok ? {body: response.body} : {status: status, body: response.body}

      if status == :ok && request.piped_requests
        request.piped_requests.each do |piped_request|
          piped_request.query = piped_request.runner.pipe_data_from(request.runner, response.body)
          run_action(piped_request, stream_response)
        end
      end

      stream_response
    end

    private

    def parse_response(response)
      if response.is_a?(Hash)
        status = response[:status]
        body = response[:body]
      else
        status = :ok
        body = response
      end

      [status, body]
    end
  end
end
