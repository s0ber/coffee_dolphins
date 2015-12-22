module AStream
  class ActionResponse
    STATUSES = [:ok, :not_found, :unprocessable_entity, :unauthorized].freeze

    attr_reader :status, :request

    def initialize(status: :ok, body:, request:)
      @unsafe_body, @request, @status = body, request, status

      if request.runner.collection_action? && !@unsafe_body.respond_to?(:each)
        raise ArgumentError, message: "Collection action should always respond with collection, but non-iterateble response specified for action #{request.runner}."
      end

      unless STATUSES.include?(@status)
        raise ArgumentError, message: "Wrong response status is specified"
      end
    end

    def body
      filtered_body
    end

    def unsafe_body
      @unsafe_body
    end

    private

    def filtered_body
      @filtered_body ||= normalizer.normalize_body
    end

    def normalizer
      ActionResponseNormalizer.new(@request, self)
    end
  end
end
