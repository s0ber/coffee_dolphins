module NeoForm
  module SimpleFormExt
    module WrapperJsView
      def js_view(js_view)
        @js_view = js_view
      end

      def default_js_view
        @js_view
      end
    end
  end
end

SimpleForm::Inputs::Base.extend NeoForm::SimpleFormExt::WrapperJsView
