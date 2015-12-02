module AStream
  class ActionStreamsBuilder

    def initialize(performer:)
      @performer = performer
    end

    def build(action_streams)
      streams = _parse(action_streams)
      _build(streams)
    end

    def _parse(action_streams)
      streams =
        if action_streams.is_a?(String)
          begin
            JSON.parse(action_streams).deep_symbolize_keys!
          rescue JSON::ParserError
            raise AStream::StreamParseError, message: "Can't parse provided action tree JSON"
          end
        elsif action_streams.is_a?(Hash)
          action_streams.respond_to?(:deep_symbolize_keys!) ? action_streams.deep_symbolize_keys!
                                                            : action_streams
        elsif action_streams.is_a?(Array)
          action_streams.map { |child_stream| _parse(child_stream) }
        else
          raise AStream::StreamParseError, message: 'Action tree should be either a hash, an array, or a valid JSON string'
        end

      [].concat([streams]).flatten
    end

    def _build(action_streams)
      action_streams = action_streams.map do |stream|
        type = stream[:post] ? :post : :get
        runner = AStream.find_class(stream[type])
        request = ActionRequest.new(runner: runner,
                                    performer: @performer,
                                    type: type,
                                    query: stream[:query])

        _build_piped_stream(request, stream[:pipe]) if stream[:pipe]
        request
      end
    end

    def _build_piped_stream(accumulator, stream)
      if stream.is_a?(Hash)
        key, value = stream.first # read only first pair in a hash
        request = _create_piped_request(key)

        if request.runner.can_accept_action?(accumulator.runner)
          accumulator.piped_requests = request
          _build_piped_stream(request, value)
        end

      elsif stream.is_a?(Array)
        accumulator.piped_requests = stream.map do |s|
          request = _create_piped_request(s)
          if request.runner.can_accept_action?(accumulator.runner)
            request
          end
        end.compact

      elsif stream.is_a?(String)
        request = _create_piped_request(stream)

        if request.runner.can_accept_action?(accumulator.runner)
          accumulator.piped_requests = request
        end
      end
    end

    def _create_piped_request(action_name)
      runner = AStream.find_class(action_name)
      ActionRequest.new(runner: runner, performer: @performer)
    end
  end
end
