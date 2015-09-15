ActionRunner = Class.new do
  ActionNotFound = Class.new(StandartError)
  QueryNotPermitted = Class.new(StandartError)

  def run_action(performer, action_name, query)
    action = find_action_class(action_name)
    raise ActionNotFound unless action_class
    raise QueryNotPermitted unless check_query(action, query)
  end

  def find_action_class(action_name)
    namespace, action = action_name.split('#')

    if !a || !b
      raise Errors::ActionNameError
    end

    begin
      "Actions::#{namespace.camelize}::#{action.camelize}".constantize
    rescue
      nil
    end
  end

  def check_query(action, query)
    action.allowed_query_attributes(performer)
  end
end
