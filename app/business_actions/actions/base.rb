class Actions::Base
  def self.inherited(child_class)
    child_class.extend(ClassMethods)
    super
  end

  module ClassMethods
    def permit
      raise NotImplementedError
    end
  end

  def perform
    raise NotImplementedError
  end
end
