class ApplicationDecorator < Draper::Decorator
  BLANK_VALUE = '—'
  delegate_all

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
      h.polymorphic_path(object, action: :edit),
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
    h.link_to h.fa_icon('close'),
      h.polymorphic_path(object),
      class: 'small_button is-icon is-red',
      remote: true,
      method: :delete,
      data: {role: 'item-remove_button', confirm: confirm_remove_message}
  end

protected
  def confirm_remove_message
    raise NotImplementedError
  end
end

