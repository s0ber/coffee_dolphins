module AStream
  class BaseAction
    attr_reader :controller

    def initialize(controller: nil)
      @controller = controller
    end

    def self.collection_action?
      false
    end

    def self.inherited(child)
      child.class_eval do
        @can_accept_actions = {}
        @query_params = []
        @safe_attributes = []
        @included_resources = @resource_permission_check = nil

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
          @query_params =
            if block_given?
              block
            else
              args[0].respond_to?(:each) ? args[0] : args
            end
        end

        def self.permitted_query_params(performer)
          if @query_params.is_a?(Proc)
            @query_params.call(performer)
          else
            @query_params
          end
        end

        def self.included_resources(*args)
          @included_resources = args.to_a
        end

        def self.allows_included_resources?
          !!@included_resources
        end

        def self.allows_to_include_resource?(resource_name)
          return false unless @included_resources
          @included_resources.include?(resource_name)
        end

        def self.safe_attributes(*args, &block)
          @safe_attributes =
            if block_given?
              block
            else
              args[0].respond_to?(:each) ? args[0] : args
            end
        end

        def self.permitted_safe_attributes(performer)
          if @safe_attributes.is_a?(Proc)
            @safe_attributes.call(performer)
          else
            @safe_attributes
          end
        end

        def self.permit_resource(*args, &block)
          @resource_permission_check = block_given? ? block : args[0]
        end

        def self.permit_resource?(performer, resource)
          if @resource_permission_check.nil?
            raise PermissionCheckNotSpecified, message: "Please specify permission check for action #{self}"
          end

          if @resource_permission_check.is_a?(Proc)
            !!@resource_permission_check.call(performer, resource)
          else
            !!@resource_permission_check
          end
        end
      end
    end
  end
end
