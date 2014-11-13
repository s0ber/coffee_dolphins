module ListsHelper
  def list_item(label, value = '', &block)
    label = content_tag(:div, label, class: 'panel_list-label')
    if block_given?
      value = capture(&block)
    end
    value = content_tag(:div, value, class: 'panel_list-value')

    list_row(label + value)
  end

  def list_text(value)
    value = content_tag(:p, value, class: 'panel-text')
    list_row(value)
  end

  def list_row(value = '', &block)
    value = capture(&block) if block_given?
    content_tag(:div, value, class: 'panel_list-row')
  end
end
