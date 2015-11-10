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
  end
end
