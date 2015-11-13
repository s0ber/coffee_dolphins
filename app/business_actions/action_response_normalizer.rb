class ActionResponseNormalizer
  DEFAULT_SAFE_ATTRIBUTES = [:id]

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
    return [] unless action.respond_to?(:permit)

    resources.select do |item|
      action.permit(@performer, item)
    end
  end

  def serialize_resources(action: @action, resources:)
    unless action.respond_to?(:safe_attributes)
      raise AStream::SafeAttributesNotSpecified, message: "Please specify safe attributes for action #{action}"
    end

    unless (safe_attrs = action.safe_attributes(@performer)).is_a?(Array)
      raise AStream::SafeAttributesNotSpecified, message: "Safe attributes for action #{action} are not valid array"
    end

    safe_attrs = safe_attrs.select { |attr| attr.is_a?(Symbol) }
    safe_attrs = DEFAULT_SAFE_ATTRIBUTES.concat(safe_attrs)

    resources.map do |r|
      if r.respond_to?(:serializable_hash)
        r.serializable_hash.symbolize_keys.slice(*safe_attrs)
      elsif r.is_a?(Hash)
        r.slice(*safe_attrs)
      end
    end.compact
  end

  def normalize_included_resources(requested_included_resources, safe_body)
    return safe_body if !@action.respond_to?(:included_resources) || @unsafe_body.empty?

    requested_included_resources.each do |resource_name|
      if can_read_included_resources?(resource_name)
        action = AStream.find_class("#{resource_name}#show")

        safe_body.each_with_index do |item, i|
          included_resources = @unsafe_body[i].send(resource_name)
          safe_body[i][resource_name] = normalize_resources(action, included_resources)
        end
      end
    end

    safe_body
  end

  private

  def can_read_included_resources?(resource_name)
    @action.included_resources.include?(resource_name) && @unsafe_body.first.respond_to?(resource_name)
  end

  def normalize_resources(action, resources)
    filtered_resources = filter_resources(action: action, resources: resources)
    serialize_resources(action: action, resources: filtered_resources)
  end
end
