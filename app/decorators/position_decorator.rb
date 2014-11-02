class PositionDecorator < ApplicationDecorator
  def edit_button
    h.link_to 'Редактировать',
      h.edit_position_path(object),
      class: 'small_button',
      remote: true,
      data: {role: 'edit_item_button'}
  end

  def remove_button
    h.link_to 'Удалить',
      h.position_path(object),
      class: 'small_button is-red',
      remote: true,
      method: :delete,
      data: {role: 'remove_item_button', confirm: "Удалить позицию #{object.title}?"}
  end
end
