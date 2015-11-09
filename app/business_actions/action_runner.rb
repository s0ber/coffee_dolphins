module ActionRunner
  extend self

  ActionNotFound = Class.new(StandardError)

  def run_action(performer, action_name, query, type: :read)
    action = find_class(action_name)
    query = ActionQueryNormalizer.normalize_query(action, query)
  #
  #   read_response = action.perform_read(performer, query)
  #   read_response = ActionResponse.new(body: action_response, query: query)
  #
  #   read_response = filter_restricted_items(action, performer, read_response)
  #   serialize_response(action, performer, read_response)
  end

  def find_class(action_name)
    namespace, action = action_name.split('#')
    raise ActionNotFound, message: 'Action namespace is not specified.' if namespace.blank?
    raise ActionNotFound, message: 'Action name is not specified.' if action.blank?

    begin
      "Actions::#{namespace.camelize}::#{action.camelize}".constantize
    rescue => e
      raise ActionNotFound, message: "Can't find action #{action_name}."
    end
  end

  def serialize_response(action, performer, action_response)
    serialized_response = action_response.body.each do |item|
      action.serialize(performer, item)
    end

    ActionResponse.new(body: serialized_response)
  end
end
