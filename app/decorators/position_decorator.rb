class PositionDecorator < ApplicationDecorator
  def like_button
    h.content_tag :span, h.fa_icon('heart') + h.fa_icon('heart-o'),
      class: "small_button is-icon is-like #{'is-liked' if object.liked?}",
      remote: true,
      method: :put,
      data: {role: 'like_item_button', like_path: h.like_position_path(object), unlike_path: h.unlike_position_path(object)}
  end

  def edit_button
    h.link_to h.fa_icon('pencil'),
      h.edit_position_path(object),
      class: 'small_button is-icon',
      remote: true,
      data: {role: 'edit_item_button'}
  end

  def remove_button
    h.link_to h.fa_icon('close'),
      h.position_path(object),
      class: 'small_button is-icon is-red',
      remote: true,
      method: :delete,
      data: {role: 'remove_item_button', confirm: "Удалить позицию #{object.title}?"}
  end
end
