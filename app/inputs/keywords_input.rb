class KeywordsInput < SimpleForm::Inputs::CollectionInput
  wrapper_class 'text_box'
  js_view 'app#keywords'

  def input
    @builder.input_field(attribute_name, input_html_options)
  end

  def input_html_options
    super.merge(
      as: :string,
      value: '',
      name: '',
      data: {
        object_name: object_name,
        associated_attributes_name: reflection_or_attribute_name.to_s + '_attributes',
        associated_attributes_collection: object.send(reflection_or_attribute_name.to_sym)
      }
    )
  end
end

