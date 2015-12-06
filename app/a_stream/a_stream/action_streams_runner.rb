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

      if request.type == :get
        response = action.perform_read(@performer, request.query)
      else
        response = action.perform_update(@performer, request.query)
      end

      status, body = parse_response(response)
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
      if response.is_a?(AStream::Response)
        status = response.status
        body = response.body
      else
        status = :ok
        body = response
      end

      [status, body]
    end
  end
end
