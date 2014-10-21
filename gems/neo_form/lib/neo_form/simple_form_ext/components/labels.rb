module SimpleForm
  module Components
    module Labels

      alias_method :old_label_text, :label_text

      def label_text
        ('<span class="label_wrap">' + old_label_text + '</span>').html_safe
      end

    end
  end
end
