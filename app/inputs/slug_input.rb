class SlugInput < SimpleForm::Inputs::StringInput
  wrapper_class 'text_box'
  js_view 'app#slug'

  def input_html_options
    super.merge(as: :string)
  end
end
