module AStream
  module ActionStreamsRunner
    extend self

    def run(performer, action_streams)
      request_data = {}
      action_streams.each do |request|
        run_action(performer, request)
      end
    end

    def run_action(performer, request)
      response = request.runner.perform_read(performer, request.query)
      status = :ok

      response =
        if response.is_a?(Hash)
          status = response[:status]
          body = response[:body]
          ActionResponse.new(body: response[:body], status: response[:status], request: request)
        else
          ActionResponse.new(body: response, request: request)
        end

      if status == :ok && request.piped_requests
        request.piped_requests.each do |piped_request|
          piped_request.query = piped_request.runner.pipe_data_from(request.runner, response.body)
          run_action(performer, piped_request)
        end
      end
    end
  end
end
