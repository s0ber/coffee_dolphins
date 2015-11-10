class ActionRequest
  ALLOWED_TYPES = [:get, :post].freeze

  attr_reader :name, :type, :query

  def initialize(name:, type:, query:, child_actions: [])
    @name, @type, @query = name, type, query

    unless ALLOWED_TYPES.include?(@type)
      raise ArgumentError, message: "ActionRequest#type should be either :get or :post, but :#{@type} is provided"
    end
  end
end
