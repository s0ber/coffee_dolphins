class Actions::Base
  def self.permit(&block)
    @permission_check = block
  end

  module ClassMethods
    def permit
      raise NotImplementedError
    end
  end

  def perform
    raise NotImplementedError
  end

  def check_permissions
    @response.data.each do |item|
      @permission_check.call(item)
    end
  end
end
