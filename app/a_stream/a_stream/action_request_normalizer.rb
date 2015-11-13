module AStream
  module ActionRequestNormalizer
    extend self

    def normalize_query(action, performer, query)
      query = _filter_attributes(action, performer, query)
      _filter_included_resources(action, performer, query)
    end

    def _filter_attributes(action, performer, query)
      allowed_attrs = action.permitted_query_attributes(performer).map do |item|
        if item.is_a?(Hash)
          item.delete(:included)
          item
        elsif item == :included
          nil
        else
          item
        end
      end

      allowed_attrs = allowed_attrs.compact.push(included: [])
      ActionController::Parameters.new(query).permit(*allowed_attrs).symbolize_keys
    end

    def _filter_included_resources(action, performer, query)
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
  end
end
