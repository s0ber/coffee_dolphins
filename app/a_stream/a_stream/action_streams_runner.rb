module AStream
  module ActionStreamsRunner
    extend self

    def run(performer, action_streams)
      request_data = {}
      response = {}

      action_streams.each do |request|
        response.merge!(run_action(performer, request))
      end

      response
    end

    def run_action(performer, request, stream_response = {})
      response = request.runner.perform_read(performer, request.query)

      if response.is_a?(Hash)
        status = response[:status]
        body = response[:body]
      else
        status = :ok
        body = response
      end

      response = ActionResponse.new(status: status, body: response, request: request)
      namespace, action = request.runner.action_name.split('#')

      stream_response[:"#{namespace}_#{action}"] =
        status == :ok ? {body: response.body} : {status: status, body: response.body}

      if status == :ok && request.piped_requests
        request.piped_requests.each do |piped_request|
          piped_request.query = piped_request.runner.pipe_data_from(request.runner, response.body)
          run_action(performer, piped_request, stream_response)
        end
      end

      stream_response
    end
  end
end
