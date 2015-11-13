module AStream
  extend self

  StreamParseError = Class.new(StandardError)
  ActionNotFound = Class.new(StandardError)
  CantPipeAction = Class.new(StandardError)
  SafeAttributesNotSpecified = Class.new(StandardError)

  def run(performer, action_streams)
    action_streams = ActionStreamsBuilder.new(performer).build(action_streams)
    ActionStreamsRunner.run(performer, action_streams)
  end

  def can_pipe_actions(source, receiver)
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

  class BaseAction
    def self.can_accept_action?(action_name)
      @can_accept_actions ||= {}
      !!@can_accept_actions[action_name]
    end

    def self.query_by(action_name, &block)
      @can_accept_actions ||= {}
      @can_accept_actions[action_name] = block
    end
  end
end
