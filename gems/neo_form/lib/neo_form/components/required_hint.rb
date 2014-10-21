module NeoForm
  module Components
    module RequiredHint
      def self.included(base)
        base.alias_method_chain :hint, :required
      end

      def hint_with_required
        @hint ||= [("*required" if required_field?), hint_without_required.presence].compact.join("<br/>").html_safe
      end
    end
  end
end
