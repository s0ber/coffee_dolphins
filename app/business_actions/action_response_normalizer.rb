module ActionResponseNormalizer
  DEFAULT_SAFE_ATTRIBUTES = [:id]

  extend self

  def normalize_body(request, response)
    action, performer, unsafe_body = request.runner, request.performer, response.unsafe_body

    safe_body = _filter_resources(action, performer, unsafe_body)
    safe_body = _serialize_resources(action, performer, safe_body)

    if request.query && request.query[:included]
      safe_body = _filter_included_resources(action, performer, request.query[:included], safe_body, unsafe_body)
    end

    safe_body
  end

  def _filter_resources(action, performer, unsafe_body)
    return [] unless action.respond_to?(:permit)

    unsafe_body.select do |item|
      action.permit(performer, item)
    end
  end

  def _serialize_resources(action, performer, unsafe_resources)
    unless action.respond_to?(:safe_attributes)
      raise AStream::SafeAttributesNotSpecified, message: "Please specify safe attributes for action #{action}"
    end

    unless (safe_attrs = action.safe_attributes(performer)).is_a?(Array)
      raise AStream::SafeAttributesNotSpecified, message: "Safe attributes for action #{action} are not valid array"
    end

    safe_attrs = safe_attrs.select { |attr| attr.is_a?(Symbol) }
    safe_attrs = DEFAULT_SAFE_ATTRIBUTES.concat(safe_attrs)

    unsafe_resources.map do |r|
      if r.respond_to?(:serializable_hash)
        r.serializable_hash.symbolize_keys.slice(*safe_attrs)
      elsif r.is_a?(Hash)
        r.slice(*safe_attrs)
      end
    end.compact
  end

  def _filter_included_resources(action, performer, requested_included_resources, safe_body, unsafe_body)
    return safe_body unless action.respond_to?(:included_resources)

    unsafe_body.each_with_index do |unsafe_resource, i|
      included_resources = requested_included_resources.select do |resource_name|
        if action.included_resources.include?(resource_name) && unsafe_resource.respond_to?(resource_name)
          resources = unsafe_resource.send(resource_name)
          resources_action = AStream.find_class("#{resource_name}#show")
          filtered_resources = _filter_resources(resources_action, performer, resources)
          safe_body[i][resource_name] = _serialize_resources(resources_action, performer, filtered_resources)
        end
      end
    end

    safe_body
  end
end
