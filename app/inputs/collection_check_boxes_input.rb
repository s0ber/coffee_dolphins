class CollectionCheckBoxesInput < SimpleForm::Inputs::CollectionCheckBoxesInput

protected

  def build_nested_boolean_style_item_tag(collection_builder)
    collection_builder.check_box + template.content_tag(:span, collection_builder.text, class: 'label_wrap')
  end
end
