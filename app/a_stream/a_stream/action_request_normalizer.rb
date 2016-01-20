module AStream
  module ActionRequestNormalizer
    extend self

    def normalize_query(action, performer, query)
      query = _normalize_params(query)
      _filter_included_resources(action, performer, query)
    end

    def _normalize_params(query)
      query = query.deep_symbolize_keys
      query[:included] &&= [].concat([query[:included]]).flatten
      ActionController::Parameters.new(query)
    end

    def _filter_included_resources(action, performer, query)
      filtered_query = query.dup
      return query unless query[:included]

      if action.allows_included_resources?
        filtered_query[:included] = query[:included].select do |included_resource_name|
          action.allows_to_include_resource?(included_resource_name.to_sym)
        end
        filtered_query[:included].map!(&:to_sym)
      else
        filtered_query.delete(:included)
      end

      filtered_query
    end
  end
end
