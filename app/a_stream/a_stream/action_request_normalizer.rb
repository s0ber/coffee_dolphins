module AStream
  module ActionRequestNormalizer
    extend self

    def normalize_query(action, performer, query)
      query = _normalize_params(query)
      _normalize_included(query)
    end

    def _normalize_params(query)
      query = query.deep_symbolize_keys
      query[:included] &&= [].concat([query[:included]]).flatten
      ActionController::Parameters.new(query)
    end

    def _normalize_included(query)
      return query unless query[:included]
      query[:included].map!(&:to_sym)
      query
    end
  end
end
