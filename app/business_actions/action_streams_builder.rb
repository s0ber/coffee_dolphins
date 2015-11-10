module ActionStreamsBuilder
  extend self

  def build(action_streams)
    streams = _parse(action_streams)
    _build(streams)
  end

  def _parse(action_streams)
    streams =
      if action_streams.is_a?(String)
        begin
          JSON.parse(action_streams).with_indifferent_access
        rescue JSON::ParserError
          raise ActionRunner::StreamParseError, message: "Can't parse provided action tree JSON"
        end
      elsif action_streams.is_a?(Hash)
        action_streams.with_indifferent_access
      elsif action_streams.is_a?(Array)
        action_streams.map { |child_stream| _parse(child_stream) }
      else
        raise ActionRunner::StreamParseError, message: 'Action tree should be either a hash, an array, or a valid JSON string'
      end

    [].concat([streams]).flatten
  end

  def _build(action_streams)
    action_streams = action_streams.map do |stream|
      type = stream[:post] ? :post : :get
      runner = ActionRunner.find_class(stream[type])
      request = ActionRequest.new(runner: runner, type: type, query: stream[:query])

      _build_piped_stream(request, stream[:pipe]) if stream[:pipe]
      request
    end
  end

  def _build_piped_stream(accumulator, stream)
    accumulator.piped_requests =
      if stream.is_a?(Hash)
        key, value = stream.first # read only first pair in a hash
        runner = ActionRunner.find_class(key)
        request = ActionRequest.new(runner: runner)
        _build_piped_stream(request, value)
        request
      elsif stream.is_a?(Array)
        stream.map do |s|
          runner = ActionRunner.find_class(s)
          ActionRequest.new(runner: runner)
        end
      elsif stream.is_a?(String)
        runner = ActionRunner.find_class(stream)
        ActionRequest.new(runner: runner)
      end
  end
end
