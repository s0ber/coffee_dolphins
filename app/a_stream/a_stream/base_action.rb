module AStream
  class BaseAction
    def self.inherited(child)
      child.class_eval do
        @can_accept_actions = {}
        @query_attributes = nil

        def self.action_name
          @action_name ||= name.underscore.split('/').last(2).join('#')
        end

        def self.can_accept_action?(action_class)
          !!@can_accept_actions[action_class.action_name]
        end
        singleton_class.send(:alias_method, :able_accept_action?, :can_accept_action?)

        def self.query_by(action_name, &block)
          @can_accept_actions[action_name] = block
        end

        def self.pipe_data_from(action_class, data)
          return unless can_accept_action?(action_class)
          @can_accept_actions[action_class.action_name].call(data)
        end
      end
    end
  end
end
