module NeoForm
  module FormHelper
    def neo_form_for(record, options = {}, &block)
      record = undecorate_model(record)
      simple_form_for(record, enhance_options(record, options), &block)
    end

    def neo_fields_for(record, options = {}, &block)
      record = undecorate_model(record)
      simple_fields_for(record, enhance_options(record, options), &block)
    end

  private

    def undecorate_model(record)
      if record.is_a?(Enumerable)
        record.map(&method(:undecorate_model))
      else
        record.is_a?(Draper::Decorator) ? record.object : record
      end
    end

    def enhance_options(record, options = {})
      options[:builder] = NeoForm::FormBuilder
      options[:wrapper] = :neo
      options[:html] ||= {}
      options[:html][:id] ||= neo_form_id(record)
      options[:html][:"data-entity"] = neo_form_entity(record, options)
      options[:html][:"data-modifier"] = [options[:modifier]].compact.flatten.to_s
      options[:html][:class] = [options[:html][:class], 'form'].compact.flatten.join(' ')

      options[:html][:"data-view"] = 'app#form' unless options[:custom]
      options
    end

    def object_from_array(object_or_array)
      object_or_array.is_a?(Array) ? object_or_array.last : object_or_array
    end

    def neo_form_id(record)
      object = object_from_array(record)
      action = object.respond_to?(:persisted?) && object.persisted? ? :edit : :new
      object.respond_to?(:to_key) ? dom_id(object, action) : object.to_s
    end

    def neo_form_entity(record, options)
      object = object_from_array(record)
      case object
      when String, Symbol
        object
      else
        options[:as] || ActiveModel::Naming.param_key(object)
      end
    end
  end
end

ActionView::Base.send :include, NeoForm::FormHelper
