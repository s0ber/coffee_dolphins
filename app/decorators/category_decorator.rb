class CategoryDecorator < ApplicationDecorator
  def edit_button
    h.link_to h.fa_icon('pencil'),
      h.edit_category_path(object),
      class: 'small_button is-icon',
      remote: true,
      data: {role: 'editable_item-edit_button'}
  end

  def remove_button
    h.link_to h.fa_icon('close'),
      h.category_path(object),
      class: 'small_button is-icon is-red',
      remote: true,
      method: :delete,
      data: {role: 'item-remove_button', confirm: "Удалить категорию #{object.title}?"}
  end
end
