module AStream
  class BaseAction
    def self.inherited(child)
      child.class_eval do
        @can_accept_actions = {}
        @query_params = nil
        @safe_attributes = nil

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

        def self.query_params(*args, &block)
          if block_given?
            @query_params = block
          else
            @query_params = args
          end
        end

        def self.safe_attributes(*args, &block)
          if block_given?
            @safe_attributes = block
          else
            @safe_attributes = args
          end
        end

        def self.permitted_query_params(performer)
          unless @query_params
            raise QueryParamsNotSpecified, message: "Please specify permitted query params for action #{self}"
          end

          if @query_params.is_a?(Proc)
            @query_params.call(performer)
          else
            @query_params
          end
        end

        def self.permitted_safe_attributes(performer)
          unless @safe_attributes
            raise SafeAttributesNotSpecified, message: "Please specify permitted safe attributes for action #{self}"
          end

          if @safe_attributes.is_a?(Proc)
            @safe_attributes.call(performer)
          else
            @safe_attributes
          end
        end
      end
    end
  end
end
