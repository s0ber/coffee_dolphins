module AStream
  class ActionResponseNormalizer
    DEFAULT_SAFE_ATTRIBUTES = [:id].freeze

    def initialize(request, response)
      @runner, @performer, @query, @unsafe_body = request.runner, request.performer, request.query, response.unsafe_body
    end

    def normalize_body
      return nil unless @unsafe_body

      safe_body = filter_resources
      safe_body = serialize_resources(resources: safe_body)

      if @query && @query[:included]
        safe_body = normalize_included_resources(@query[:included], safe_body)
      end

      safe_body
    end

    def filter_resources(runner: @runner, resources: @unsafe_body)
      if resources.respond_to?(:each)
        resources.select { |item| runner.permit_resource?(@performer, item) }
      else
        runner.permit_resource?(@performer, resources) ? resources : nil
      end
    end

    def serialize_resources(runner: @runner, resources:)
      unless (safe_attrs = runner.permitted_safe_attributes(@performer)).is_a?(Array)
        raise AStream::SafeAttributesNotSpecified, message: "Safe attributes for action #{runner} are not valid array"
      end

      safe_attrs = safe_attrs.select { |attr| attr.is_a?(Symbol) }
      safe_attrs = [].concat(DEFAULT_SAFE_ATTRIBUTES).concat(safe_attrs)

      if resources.is_a?(Array)
        resources.map { |r| serialize_resource(r, safe_attrs) }.compact
      else
        serialize_resource(resources, safe_attrs)
      end
    end

    def normalize_included_resources(requested_included_resources, safe_body)
      return safe_body if !@runner.respond_to?(:included_resources) || @unsafe_body.nil? || @unsafe_body.try(:empty?)

      requested_included_resources.each do |resource_name|
        if can_read_included_resources?(resource_name)
          runner = AStream.find_class("#{resource_name.to_s.pluralize}#show")

          if safe_body.is_a?(Array)
            safe_body.each_with_index do |item, i|
              included_resources = @unsafe_body[i].send(resource_name)
              safe_body[i][resource_name] = normalize_resources(runner, included_resources)
            end
          else
            included_resources = @unsafe_body.send(resource_name)
            safe_body[resource_name] = normalize_resources(runner, included_resources)
          end
        end
      end

      safe_body
    end

    private

    def can_read_included_resources?(resource_name)
      @runner.allows_to_include_resource?(resource_name) && (@unsafe_body.respond_to?(:each) ? @unsafe_body.first.respond_to?(resource_name)
                                                                                             : @unsafe_body.respond_to?(resource_name))
    end

    def serialize_resource(resource, safe_attrs)
      if resource.respond_to?(:serializable_hash)
        resource.serializable_hash.deep_symbolize_keys.slice(*safe_attrs)
      elsif resource.is_a?(Hash)
        resource.slice(*safe_attrs)
      end
    end

    def normalize_resources(runner, resources)
      filtered_resources = filter_resources(runner: runner, resources: resources)
      serialize_resources(runner: runner, resources: filtered_resources)
    end
  end
end
