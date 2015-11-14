module AStream
  class ActionRequest
    ALLOWED_TYPES = [:get, :post].freeze

    attr_reader :runner, :type, :performer

    def initialize(runner:, type: :get, query: nil, pipe: nil, performer: nil)
      @runner, @type, @query, @performer = runner, type, query, performer

      unless ALLOWED_TYPES.include?(@type)
        raise ArgumentError, message: "ActionRequest#type should be either :get or :post, but :#{@type} is provided"
      end

      if !runner.is_a?(Class) || !runner.ancestors.include?(AStream::BaseAction)
        raise ArgumentError, message: 'ActionRequest#runner should be an AStream::BaseAction class'
      end

      (self.piped_requests = pipe) if pipe
    end

    def query
      normalized_query if @query
    end

    def query=(new_query)
      @query = new_query unless @query
    end

    def action_name
      runner.action_name
    end

    def piped_requests=(action_requests)
      @piped_requests ||=
        if action_requests.is_a?(Array)
          if action_requests.all? { |request| request.is_a?(AStream::ActionRequest) }
            action_requests
          else
            raise ArgumentError, message: 'Only ActionRequest instances can be piped'
          end
        elsif action_requests.is_a?(AStream::ActionRequest)
          action_requests
        else
          raise ArgumentError, message: 'Only ActionRequest instances can be piped'
        end
    end

    def piped_requests
      @piped_requests
    end

    protected

    def ==(o)
      return false unless o
      runner == o.runner &&
        type == o.type &&
        query == o.query &&
        piped_requests == o.piped_requests &&
        performer == o.performer
    end

    private

    def normalized_query
      @normalized_query ||= ActionRequestNormalizer.normalize_query(@runner, @performer, @query)
    end
  end
end
