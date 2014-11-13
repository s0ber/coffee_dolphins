class PositionDecorator < ApplicationDecorator
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
