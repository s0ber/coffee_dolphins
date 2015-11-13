module AStream
  module ActionRequestNormalizer
    extend self

    def normalize_query(action, query)
      query = _filter_attributes(action, query)
      query = _filter_included_resources(action, query)
      _filter_child_actions(action, query).symbolize_keys
    end

    def _filter_attributes(action, query)
      unless action.respond_to?(:query_attributes)
        raise NoMethodError, message: "Allowed query attributes are not specified for action #{action}."
      end

      query = ActionController::Parameters.new(query)

      allowed_attrs = action.query_attributes.map do |item|
        if item.is_a?(Hash)
          item.delete(:included)
          item.delete(:child_actions)
          item
        elsif item == :included || item == :child_actions
          nil
        else
          item
        end
      end
      allowed_attrs = allowed_attrs.compact.push(included: [], child_actions: [])

      query.permit(*allowed_attrs)
    end

    def _filter_included_resources(action, query)
      filtered_query = query.dup

      if action.respond_to?(:included_resources)
        filtered_query[:included] = query[:included].select do |included_resource_name|
          action.included_resources.include?(included_resource_name.to_sym)
        end
        filtered_query[:included].map!(&:to_sym)
      else
        filtered_query.delete(:included)
      end

      filtered_query
    end

    def _filter_child_actions(action, query)
      filtered_query = query.dup

      if action.respond_to?(:child_actions)
        filtered_query[:child_actions] = query[:child_actions].map do |child_action_string|
          begin
            child_action = AStream.find_class(child_action_string)
            if action.child_actions.include?(child_action)
              child_action
            else
              nil
            end
          rescue AStream::ActionNotFound => e
            nil
          end
        end.compact
      else
        filtered_query.delete(:child_actions)
      end

      filtered_query
    end

    # def filter_restricted_items(action, performer, action_response, query)
    #   included_resources_names = action_response.query[:include]
    #
    #   filtered_reponse = action_response.body.select do |item|
    #     action.permit(performer, item)
    #   end
    #
    #   if included_resources_names
    #     filtered_reponse.each do |item|
    #       filter_included_resources(performer, item, included_resources_names)
    #     end
    #   end
    #
    #   ActionResponse.new(body: filtered_reponse)
    # end

    # def filter_included_resources(performer, item, included_resources_names)
    #   included_resources_names.each do |resource_name|
    #     resource_name = resource_name.to_sym
    #
    #     included_items = item.send(resource_name)
    #     resource_show_action = find_action_namespace("#{resource_name}#show")
    #
    #     filtered_included_resources = included_items.select do |included_item|
    #       resource_show_action.permit(performer, included_item)
    #     end
    #
    #     item.send(resource_name, filtered_included_resources)
    #   end
    # end
  end
end
