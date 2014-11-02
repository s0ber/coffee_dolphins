module ListsHelper
  def list_item(label, value)
    label = content_tag(:div, label, class: 'panel-list_label')
    value = content_tag(:div, value, class: 'panel-list_value')
    content_tag(:div, label + value, class: 'panel-list_row')
  end

  def list_text(value)
    value = content_tag(:p, value, class: 'panel-text')
    content_tag(:div, value, class: 'panel-list_row')
  end
end
