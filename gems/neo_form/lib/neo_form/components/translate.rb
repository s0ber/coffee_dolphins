module NeoForm
  module Components
    module Translate

      private

      def lookup_model_scopes
        # if object.is_a?(Role)
        #   [object.class.model_name.underscore, 'user']
        # else
          model_names = @builder.lookup_model_names
          (0..model_names.size - 1).map { |index| model_names[index..-1].join(".") }
        # end
      end

      def translate(namespace, default = '')
        lookups = []

        lookup_model_scopes.each do |model_scope|
          lookups << :"#{model_scope}.#{lookup_action}.#{reflection_or_attribute_name}"
          lookups << :"#{model_scope}.#{reflection_or_attribute_name}"
        end
        lookups << :"defaults.#{lookup_action}.#{reflection_or_attribute_name}"
        lookups << :"defaults.#{attribute_name}"
        lookups << default

        I18n.t(lookups.shift, :scope => :"neo_form.#{namespace}", default: lookups).presence
      end
    end
  end
end
