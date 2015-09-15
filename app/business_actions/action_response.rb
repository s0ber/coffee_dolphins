class ActionResponse
  STATUSES = [:ok, :not_found, :unprocessable_entity, :unathorized]

  class OK; end
  class NotFound; end
  class UnprocessableEntity; end
  class Unathorized; end

  attr_reader :status
  attr_reader :data

  def initialize
  end
end
