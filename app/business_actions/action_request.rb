class ActionRequest
  ALLOWED_TYPES = [:get, :post].freeze

  attr_reader :runner, :type

  def initialize(runner:, type:, query:, child_actions: [])
    @runner, @type, @query = runner, type, query

    unless ALLOWED_TYPES.include?(@type)
      raise ArgumentError, message: "ActionRequest#type should be either :get or :post, but :#{@type} is provided"
    end

    if !runner.is_a?(Class) || !(runner.name =~ /^Actions::/)
      raise ArgumentError, message: 'ActionRequest#runner should be an Action class'
    end
  end

  def query
    normalized_query
  end

  private

  def normalized_query
    @_normalized_query ||= ActionQueryNormalizer.normalize_query(@runner, @query)
  end
end
