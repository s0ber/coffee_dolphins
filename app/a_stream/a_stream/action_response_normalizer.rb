module AStream
  class ActionResponseNormalizer
    DEFAULT_SAFE_ATTRIBUTES = [:id].freeze

    def initialize(request, response)
      @runner, @performer, @query, @unsafe_response = request.runner, request.performer, request.query, response.unsafe_body
    end

    def normalize_body
      return nil unless @unsafe_response

      response = serialize_body
      response = permit_and_filter_response(response, @runner)
      permit_and_filter_included_response(response)
    end

    def serialize_body
      if @unsafe_response.respond_to?(:each) && !@unsafe_response.is_a?(Hash)
        @unsafe_response.map { |resource| serialize_resource(resource) }
      else
        serialize_resource(@unsafe_response)
      end
    end

    def permit_and_filter_response(response, runner)
      safe_attrs = safe_attrs_for_action(runner)

      # here we are calling it a response, but it may be a single resource (hash),
      # or an array of resources (array of hashes)
      if response.is_a?(Array)
        response = response.select { |resource| runner.permit_resource?(@performer, resource) }
        response.map { |resource| resource.slice(*safe_attrs) }
      else
        if response && runner.permit_resource?(@performer, response)
          response.slice(*safe_attrs)
        else
          nil
        end
      end
    end

    def permit_and_filter_included_response(response)
      return response unless @query[:included]

      @query[:included].each do |included_response_name|
        runner = AStream.find_class("#{included_response_name.to_s.pluralize}#show")

        if response.is_a?(Array)
          response.each do |resource|
            resource[included_response_name] = permit_and_filter_response(resource[included_response_name], runner)
          end
        else
          response[included_response_name] = permit_and_filter_response(response[included_response_name], runner)
        end
      end

      response
    end

    private

    def serialize_resource(resource)
      if resource.respond_to?(:serializable_hash)
        resource.serializable_hash(include: @query[:included]).deep_symbolize_keys
      elsif resource.is_a?(Hash)
        resource
      else
        raise AStream::CantSerializeResource, message: "Action should return either collection, or array of ActiveRecord objects (or hashes), or just one ActiveRecord object (or hash)"
      end
    end

    def safe_attrs_for_action(runner)
      safe_attrs = runner.permitted_safe_attributes(@performer)
      unless safe_attrs.is_a?(Array)
        raise AStream::SafeAttributesNotSpecified, message: "Safe attributes for action #{runner} are not valid array"
      end

      safe_attrs = safe_attrs.select { |attr| attr.is_a?(Symbol) }
      [].concat(DEFAULT_SAFE_ATTRIBUTES).concat(safe_attrs)
    end
  end
end
