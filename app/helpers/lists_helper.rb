module ListsHelper
  def list_item(label, value)
    label = content_tag(:div, label, class: 'panel-list_label')
    value = content_tag(:div, value, class: 'panel-list_value')
    list_row(label + value)
  end

  def list_text(value)
    value = content_tag(:p, value, class: 'panel-text')
    list_row(value)
  end

  def list_row(value)
    content_tag(:div, value, class: 'panel-list_row')
  end
end
