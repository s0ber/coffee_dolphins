module AStream
  class ActionResponseNormalizer
    DEFAULT_SAFE_ATTRIBUTES = [:id].freeze

    def initialize(request, response)
      @action, @performer, @query, @unsafe_body = request.runner, request.performer, request.query, response.unsafe_body
    end

    def normalize_body
      safe_body = filter_resources
      safe_body = serialize_resources(resources: safe_body)

      if @query && @query[:included]
        safe_body = normalize_included_resources(@query[:included], safe_body)
      end

      safe_body
    end

    def filter_resources(action: @action, resources: @unsafe_body)
      if resources.respond_to?(:each)
        resources.select { |item| action.permit_resource?(@performer, item) }
      else
        action.permit_resource?(@performer, resources) ? resources : nil
      end
    end

    def serialize_resources(action: @action, resources:)
      unless (safe_attrs = action.permitted_safe_attributes(@performer)).is_a?(Array)
        raise AStream::SafeAttributesNotSpecified, message: "Safe attributes for action #{action} are not valid array"
      end

      safe_attrs = safe_attrs.select { |attr| attr.is_a?(Symbol) }
      safe_attrs = [].concat(DEFAULT_SAFE_ATTRIBUTES).concat(safe_attrs)

      if resources.respond_to?(:each) && !resources.is_a?(Hash)
        resources.map { |r| serialize_resource(r, safe_attrs) }.compact
      else
        serialize_resource(resources, safe_attrs)
      end
    end

    def normalize_included_resources(requested_included_resources, safe_body)
      return safe_body if !@action.respond_to?(:included_resources) || @unsafe_body.nil? || (@action.collection_action? && @unsafe_body.empty?)

      requested_included_resources.each do |resource_name|
        if can_read_included_resources?(resource_name)
          action = AStream.find_class("#{resource_name.to_s.pluralize}#show")

          if @action.collection_action?
            safe_body.each_with_index do |item, i|
              included_resources = @unsafe_body[i].send(resource_name)
              safe_body[i][resource_name] = normalize_resources(action, included_resources)
            end
          else
            included_resources = @unsafe_body.send(resource_name)
            safe_body[resource_name] = normalize_resources(action, included_resources)
          end
        end
      end

      safe_body
    end

    private

    def can_read_included_resources?(resource_name)
      @action.allows_to_include_resource?(resource_name) && (@action.collection_action? ? @unsafe_body.first.respond_to?(resource_name)
                                                                                        : @unsafe_body.respond_to?(resource_name))
    end

    def serialize_resource(resource, safe_attrs)
      if resource.respond_to?(:serializable_hash)
        resource.serializable_hash.symbolize_keys.slice(*safe_attrs)
      elsif resource.is_a?(Hash)
        resource.slice(*safe_attrs)
      end
    end

    def normalize_resources(action, resources)
      filtered_resources = filter_resources(action: action, resources: resources)
      serialize_resources(action: action, resources: filtered_resources)
    end
  end
end
