module NeoForm
  module SimpleFormExt
    module WrapperClass
      def wrapper_class(wrapper_class)
        @wrapper_class = wrapper_class
      end

      def default_wrapper_class
        @wrapper_class
      end
    end
  end
end

SimpleForm::Inputs::Base.extend NeoForm::SimpleFormExt::WrapperClass