module NeoForm
  class FormBuilder < SimpleForm::FormBuilder
    def input(attribute_name, options = {}, &block)
      (options[:input_html] ||= {}).tap do |input_options|
        input_options[:id] ||= input_id_for(attribute_name)
        input_options[:class] = ['input', input_options[:class]].flatten.compact
      end
      super
    end

    def input_if_exist(attribute_name, options = {}, &block)
      if object.respond_to?(attribute_name) && object.respond_to?(:"#{attribute_name}=")
        input(attribute_name, options, &block)
      end
    end

    def input_id_for(attribute_name)
      "#{prefix}_#{sanitized_name(attribute_name)}"
    end

    def submit(value, options = {})
      options[:id] ||= "save_#{prefix}"
      super
    end

    def prefix
      @prefix ||= if @options[:prefix]
        @options[:prefix]
      elsif object.present?
        @template.dom_id(object)
      else
        object_name
      end
    end

    def sanitized_name(name)
      name.to_s.sub(/\?$/, "")
    end

    private

    def find_mapping(input_type)
      discovery_cache[input_type] ||= Class.new(super) do
        include NeoForm::Components::Translate
        #include NeoForm::Components::RequiredHint
        include NeoForm::Components::WrapperClass
        include NeoForm::Components::WrapperJsView

        wrapper_class superclass.default_wrapper_class
        js_view superclass.default_js_view
      end
    end
  end
end
