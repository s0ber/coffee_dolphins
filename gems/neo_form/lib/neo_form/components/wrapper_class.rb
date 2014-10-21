module NeoForm
  module Components
    module WrapperClass
      CLASSES = {
        string: 'text_box',
        password: 'text_box',
        email: 'text_box',
        tel: 'text_box',
        text: 'textarea',
        select: 'select_box',
        radio_buttons: 'radio_buttons_list',
        time_zone: 'select_box',
        boolean: 'check_box',
        check_boxes: 'check_boxes_list',
        file: 'ui-file',
        neo_file: 'ui-file',
        display: 'ui-display'
      }

      def wrapper_class
        base_class = if is_nested_form?
          CLASSES[input_type]
        else
          self.class.default_wrapper_class || CLASSES[input_type]
        end

        base_class && [base_class, modifier].compact.flatten
      end

      private

      def is_nested_form?
        self.class.default_wrapper_class == 'nested_form'
      end

      def modifier
        @modifiers = [options[:modifier] || @builder.options[:modifier]].compact.flatten
        @modifier  = @modifiers.map { |m| "is-#{m}"}
      end
    end
  end
end
