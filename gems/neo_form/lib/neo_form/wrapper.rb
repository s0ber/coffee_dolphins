module NeoForm
  class Wrapper
    def initialize(simple_form_wrapper)
      @simple_form_wrapper = simple_form_wrapper
    end

    def render(input)
      @simple_form_wrapper.options[:wrapper_class] = [input.wrapper_class, 'js-field_wrapper'] if input.respond_to? :wrapper_class
      @simple_form_wrapper.render(input)
    end

    def find(name)
      @simple_form_wrapper.find(name)
    end
  end
end

SimpleForm.wrappers[:neo] = NeoForm::Wrapper.new(SimpleForm.wrappers[SimpleForm.default_wrapper])
