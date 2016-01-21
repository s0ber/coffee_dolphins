module AStream
  StreamParseError = Class.new(StandardError)
  ActionNotFound = Class.new(StandardError)
  CantPipeAction = Class.new(StandardError)
  QueryParamsNotSpecified = Class.new(StandardError)
  SafeAttributesNotSpecified = Class.new(StandardError)
  PermissionCheckNotSpecified = Class.new(StandardError)
  CantSerializeResource = Class.new(StandardError)

  def self.run(performer, action_streams, controller)
    action_streams = ActionStreamsBuilder.new(performer: performer).build(action_streams)
    ActionStreamsRunner.new(performer: performer, controller: controller).run(action_streams)
  end

  def self.find_class(action_name)
    namespace, action = action_name.split('#')
    raise ActionNotFound, message: 'Action namespace is not specified.' if namespace.blank?
    raise ActionNotFound, message: 'Action name is not specified.' if action.blank?

    begin
      "#{namespace.camelize}::#{action.camelize}".constantize
    rescue => e
      raise ActionNotFound, message: "Can't find action #{action_name}."
    end
  end
end
