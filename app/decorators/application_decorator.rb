class ApplicationDecorator < Draper::Decorator
  BLANK_VALUE = '—'
  delegate_all

  def link_with_arrow
    arrow = h.content_tag(:span, '', class: 'chevron is-right')
    h.link_to(
      (h.h(object.try(:name) || object.try(:title) || 'No title') + arrow).html_safe,
      h.polymorphic_path(object)
    )
  end

  def like_button
    h.content_tag :span, h.fa_icon('heart') + h.fa_icon('heart-o'),
      class: "small_button is-icon is-like #{'is-liked' if object.liked?}",
      remote: true,
      method: :put,
      data: {view: 'app#like_button',
             like_path: h.polymorphic_path(object, action: :like),
             unlike_path: h.polymorphic_path(object, action: :unlike)}
  end

  def edit_button
    h.link_to h.fa_icon('pencil'),
      edit_path,
      class: 'small_button is-icon',
      remote: true,
      data: {role: 'editable_item-edit_button'}
  end

  def modal_edit_button
    h.content_tag :span, h.fa_icon('pencil'),
      class: 'small_button is-icon',
      data: {modal: h.polymorphic_path(object, action: :edit)}

  end

  def confirm_remove_button
    h.content_tag :span, h.fa_icon('close'),
      class: 'small_button is-icon is-red',
      data: {modal: h.polymorphic_path(object, action: :confirm_destroy)}
  end

  def remove_button
    if can_remove_object
      h.link_to h.fa_icon('close'),
        remove_path,
        class: 'small_button is-icon is-red',
        remote: true,
        method: :delete,
        data: {role: "item-remove_button #{object.class.name.underscore}-remove_button", confirm: confirm_remove_message}
    else
      h.content_tag :span, h.fa_icon('close'), class: 'small_button is-icon is-red is-disabled'
    end
  end

protected

  def edit_path
    h.polymorphic_path(object, action: :edit)
  end

  def remove_path
    h.polymorphic_path(object)
  end

  def can_remove_object
    true
  end

  def add_sign(value)
    if value > 0
      h.content_tag :b, "+#{value} RUB", class: 'status is-green'
    elsif value < 0
      h.content_tag :b, "#{value} RUB", class: 'status is-red'
    else
      "#{value} RUB"
    end
  end

  def confirm_remove_message
    raise NotImplementedError
  end
end

