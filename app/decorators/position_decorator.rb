class PositionDecorator < ApplicationDecorator
  decorates_association :notes

  def edit_button
    h.link_to h.fa_icon('pencil'),
      h.edit_position_path(object),
      class: 'small_button is-icon',
      remote: true,
      data: {role: 'editable_item-edit_button'}
  end

  def remove_button
    h.link_to h.fa_icon('close'),
      h.position_path(object),
      class: 'small_button is-icon is-red',
      remote: true,
      method: :delete,
      data: {role: 'item-remove_button', confirm: "Удалить позицию #{object.title}?"}
  end
end
