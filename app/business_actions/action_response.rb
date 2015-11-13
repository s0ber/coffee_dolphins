class ActionResponse
  STATUSES = [:ok, :not_found, :unprocessable_entity, :unathorized]

  attr_reader :status

  def initialize(status: :ok, body:, request:)
    @unsafe_body = body
    @request = request
    # @body, @status = body, status
    # raise ArgumentError unless @body.is_a?(Enumerable)
  end

  def body
    _filtered_body
  end

  def unsafe_body
    @unsafe_body
  end

  private

  def filtered_body
    @filtered_body ||= ActionResponseNormalizer::normalize_body(@request, self)
  end
end
