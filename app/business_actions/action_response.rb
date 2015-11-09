class ActionResponse
  STATUSES = [:ok, :not_found, :unprocessable_entity, :unathorized]

  attr_reader :status
  attr_reader :body

  def initialize(body: nil, status: :ok)
    # @body, @status = body, status
    # raise ArgumentError unless @body.is_a?(Enumerable)
  end

  def test
    true
  end
end
