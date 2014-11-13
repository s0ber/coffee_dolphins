class KeywordsInput < SimpleForm::Inputs::CollectionInput
  wrapper_class 'text_box'
  js_view 'app#keywords'

  def input
    @builder.input_field(attribute_name, input_html_options.merge(
      as: :string,
      value: '',
      name: '',
      data: {
        object_name: object_name,
        associated_objects_name: reflection_or_attribute_name,
        associated_objects: collection
      }
    ))
  end
end

